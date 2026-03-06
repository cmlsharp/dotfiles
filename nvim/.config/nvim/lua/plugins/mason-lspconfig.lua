return {
  "mason-org/mason-lspconfig.nvim",
  dependencies = { "mason.nvim", "nvim-lspconfig" },
  opts = {
    automatic_enable = {
      exclude = { "rust_analyzer" },
    },
  },
}
