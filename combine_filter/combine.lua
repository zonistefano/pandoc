local seen = {}

local function read_markdown_file(filename)
  -- 1. Use the path of the file as the key to prevent loops
  if seen[filename] then
    return {}
  end
  seen[filename] = true

  local file = io.open(filename, "rb")
  if not file then
    io.stderr:write("Could not open file: " .. filename .. "\n")
    return nil -- Keeps the link as is if file not found
  end

  local content = file:read("*all")
  file:close()

  -- Parse the included file
  local doc = pandoc.read(content, "markdown")
  
  -- Recursively process the blocks in the included file (for nested includes)
  return pandoc.walk_block(pandoc.Div(doc.blocks), {
    Para = Para
  }).content
end

function Para(el)
  -- Check if the paragraph contains exactly one element and that element is a Link
  -- and if the link text is empty and ends in .md
  if #el.content == 1 and el.content[1].t == "Link" then
    local link = el.content[1]
    if #link.content == 0 and link.target:match("%.md$") then
      return read_markdown_file(link.target)
    end
  end
end