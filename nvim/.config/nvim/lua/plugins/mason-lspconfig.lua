return {
  "mason-org/mason-lspconfig.nvim",
  dependencies = { "mason.nvim", "nvim-lspconfig" },
  opts = {
    ensure_installed = { "html", "cssls", "clangd", "texlab", "lua_ls" },
    automatic_enable = {
      exclude = { "rust_analyzer" },
    },
  },
}
