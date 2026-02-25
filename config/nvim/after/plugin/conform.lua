local ok, conform = pcall(require, "conform")
if not ok then
  return
end

conform.setup {
  formatters_by_ft = {
    lua = { "stylua" },
  },
}
