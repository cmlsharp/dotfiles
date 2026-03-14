return {
  "stevearc/oil.nvim",
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<C-n>", "<cmd>Oil --float<CR>", desc = "Open file browser" },
  },
  opts = {
    default_file_explorer = true,
    keymaps = {
      ["<C-n>"] = { "actions.close", mode = "n" },
    },
  },
}
