return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<C-n>", "<cmd>Oil --float<CR>", desc = "Open file browser" },
  },
  opts = {
    keymaps = {
      ["<C-n>"] = { "actions.close", mode = "n" },
    },
  },
}
