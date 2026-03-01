return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format { async = true, lsp_format = "fallback" }
      end,
      mode = "",
      desc = "[F]ormat buffer",
    },
  },
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
