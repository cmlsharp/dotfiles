return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      rust = { lsp_format = "fallback" },
      ocaml = { lsp_format = "fallback" },
      idris2 = { lsp_format = "fallback" },
    },
    format_on_save = { timeout_ms = 2000, lsp_format = "fallback" },
  },
}
