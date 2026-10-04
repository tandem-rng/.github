# Port documentation template

Every port keeps its documentation as plain markdown in `docs/`. The shared workflow renders it
with [pandoc](https://pandoc.org) to `https://tandem-rng.github.io/<repo>/`, in the type and
colours of the [landing page](https://tandem-rng.github.io), light and dark, at phone width.

## Pages

| File | Nav label | Holds |
|---|---|---|
| `index.md` | Overview | What the port is, Install, AI assistance |
| `api.md` | API | Use, Reference, other interfaces, Parallel use |
| `design.md` | Design | Fills, Bounded integers, Normals, Exponentials |
| `tests.md` | Tests | The command, Suite, Fixtures, CI |
| `speed.md` | Speed | CPU, GPU, Other generators |

`pages/` holds each file with its headings and one sentence per section on what belongs there.
Only `index.md` is required. Keep the `##` headings and their order. Delete a section that does
not apply. Add a port-specific section where its neighbours fit, for example a backend under
API. Put a long extra topic in its own page, such as `gpu.md`. It appears in the nav after the
fixed pages, labelled with its `#` heading.

## Adopt it in a port

1. Copy `pages/*.md` into `docs/` and move the existing material under the template headings.
   Move text, do not delete it. Keep every number, path and flag.
2. Copy `docs.yml` to `.github/workflows/docs.yml` and set `title` to the repository name.
3. Enable Pages from Actions once, as an org owner:
   ```sh
   gh api -X POST repos/tandem-rng/<repo>/pages -f build_type=workflow
   ```
4. Push. The workflow deploys `main` and only renders on pull requests.
5. Link the site from the README badge line and footer:
   ```markdown
   [![Docs](https://img.shields.io/badge/docs-tandem--rng.github.io-7fb3ee.svg)](https://tandem-rng.github.io/<repo>/)
   [Documentation](https://tandem-rng.github.io/<repo>/) · [Apache 2.0 license](LICENSE)
   ```

## Links

Write links as they work on GitHub. The renderer turns a link to another page, `api.md#use`,
into `api.html#use`. It turns a link out of `docs/`, such as `../tests/test_api.c`, into a
link to the file on GitHub. Images and other files inside `docs/` are copied as they are.

## Preview

Install pandoc 3.11 or newer and run from the repository root:

```sh
../tandem-dotgithub/docs-template/site/build.sh docs /tmp/site <repo> tandem-rng/<repo>
open /tmp/site/index.html
```

`site/` holds the renderer: `build.sh`, the pandoc `template.html`, `links.lua` and
`style.css`. A change there reaches every port on its next docs run. Run a port's workflow by
hand to pick it up sooner.
