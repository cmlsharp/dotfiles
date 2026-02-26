return {
  "NeogitOrg/neogit",
  cmd = "Neogit",
  keys = {
    { "<leader>gs", "<cmd>Neogit<CR>", desc = "Neogit status" },
    { "<leader>gc", "<cmd>Neogit commit<CR>", desc = "Neogit commit" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
  },
  opts = {
    integrations = {
      diffview = true,
    },
  },
}
