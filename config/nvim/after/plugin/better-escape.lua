local ok, better_escape = pcall(require, "better_escape")
if not ok then
  return
end

better_escape.setup {
  mappings = {
    c = { j = { k = false } },
    t = { j = { k = false } },
    v = { j = { k = false } },
    s = { j = { k = false } },
  },
}
