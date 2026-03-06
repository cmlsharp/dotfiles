return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown", "markdown_inline" },
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    latex = { enabled = true },
  },
}
