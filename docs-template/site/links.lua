-- Rewrites relative links so the same markdown works on GitHub and on Pages.
-- A link to a rendered page becomes .html. A link out of docs/ goes to GitHub.
local repo = os.getenv("TANDEM_REPO") or ""
local ref = os.getenv("TANDEM_REF") or "main"
local docs = os.getenv("TANDEM_DOCS_DIR") or "docs"
local pages = {}
for p in (os.getenv("TANDEM_PAGES") or ""):gmatch("%S+") do pages[p] = true end

local function normalize(path)
  local out = {}
  for part in path:gmatch("[^/]+") do
    if part == ".." then
      if #out == 0 then return nil end
      table.remove(out)
    elseif part ~= "." then
      table.insert(out, part)
    end
  end
  return table.concat(out, "/")
end

local function rewrite(target, raw)
  if target == "" or target:match("^#") or target:match("^/")
    or target:match("^%a[%w+.-]*:") then
    return nil
  end
  local path, frag = target:match("^([^#]*)(.*)$")
  local full = normalize(docs .. "/" .. path)
  if not full then return nil end
  local name = full:match("^" .. docs:gsub("%p", "%%%0") .. "/([^/]+)%.md$")
  if name and pages[name] then return name .. ".html" .. frag end
  local inside = full:sub(1, #docs + 1) == docs .. "/" and not full:match("%.md$")
  if inside or repo == "" then return nil end
  if raw then
    return "https://raw.githubusercontent.com/" .. repo .. "/" .. ref .. "/" .. full
  end
  return "https://github.com/" .. repo .. "/blob/" .. ref .. "/" .. full .. frag
end

function Link(el)
  local t = rewrite(el.target, false)
  if t then el.target = t; return el end
end

function Image(el)
  local t = rewrite(el.src, true)
  if t then el.src = t; return el end
end

-- Wide tables scroll inside their box, not the page, at phone width.
function Table(el)
  return pandoc.Div({el}, {class = "table-wrap"})
end
