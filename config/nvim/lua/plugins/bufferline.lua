return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      diagnostics = "nvim_lsp",
      always_show_bufferline = false,
      custom_filter = function(buf)
        return vim.bo[buf].buftype ~= "terminal"
      end,
    },
  },
}
