return {
  "mason-org/mason-lspconfig.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "mason.nvim", "nvim-lspconfig" },
  opts = {
    automatic_enable = {
      exclude = { "rust_analyzer" },
    },
  },
}
