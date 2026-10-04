#!/usr/bin/env bash
# Render a port's docs/ to static HTML with pandoc.
# Usage: build.sh <docs-dir> <out-dir> <title> [owner/repo] [ref]
set -euo pipefail

here=$(cd "$(dirname "$0")" && pwd)
src=${1:?docs dir}
out=${2:?out dir}
title=${3:?title}
repo=${4:-${GITHUB_REPOSITORY:-}}
ref=${5:-main}

[ -f "$src/index.md" ] || { echo "build.sh: $src/index.md is missing" >&2; exit 1; }

# The fixed pages first, in reading order, then any extra page by name.
pages=()
for p in index api design tests speed; do
  [ -f "$src/$p.md" ] && pages+=("$p")
done
for f in "$src"/*.md; do
  p=$(basename "$f" .md)
  case " ${pages[*]} " in *" $p "*) ;; *) pages+=("$p") ;; esac
done

escape() { sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g'; }

label() {
  case $1 in
    index) echo Overview ;;
    api) echo API ;;
    design) echo Design ;;
    tests) echo Tests ;;
    speed) echo Speed ;;
    *) sed -n 's/^# //p' "$src/$1.md" | head -n 1 | escape ;;
  esac
}

mkdir -p "$out"
# Images and other files next to the pages are served as they are.
(cd "$src" && find . -type f ! -name '*.md' -print0) | while IFS= read -r -d '' f; do
  mkdir -p "$out/$(dirname "$f")"
  cp "$src/$f" "$out/$f"
done
cp "$here/style.css" "$here/favicon.svg" "$out/"

# Repo-relative path of the docs dir, for links that leave it. Run from the repo root or set DOCS_REL.
docs_rel=${DOCS_REL:-${src#./}}
docs_rel=${docs_rel%/}
for p in "${pages[@]}"; do
  nav=""
  for q in "${pages[@]}"; do
    cur=""
    [ "$q" = "$p" ] && cur=' aria-current="page"'
    nav+="    <a href=\"$q.html\"$cur>$(label "$q")</a>"$'\n'
  done
  if [ "$p" = index ]; then
    pagetitle="$title documentation"
  else
    pagetitle="$(sed -n 's/^# //p' "$src/$p.md" | head -n 1) · $title"
  fi
  TANDEM_REPO=$repo TANDEM_REF=$ref TANDEM_DOCS_DIR=$docs_rel TANDEM_PAGES="${pages[*]}" \
    pandoc "$src/$p.md" --from gfm --to html5 --standalone \
      --template "$here/template.html" --lua-filter "$here/links.lua" \
      --metadata pagetitle="$pagetitle" \
      -V site-title="$title" -V repo="$repo" -V ref="$ref" -V nav="$nav" \
      --output "$out/$p.html"
done
echo "build.sh: ${#pages[@]} pages in $out: ${pages[*]}"
