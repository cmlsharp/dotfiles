local ok, npairs = pcall(require, "nvim-autopairs")
if not ok then
  return
end

npairs.setup {}

-- Disable single quote pairing for OCaml
local rule = npairs.get_rule("'")
if rule and rule[1] then
  rule[1].not_filetypes = { "ocaml" }
end
