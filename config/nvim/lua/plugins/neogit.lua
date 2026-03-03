return {
  "NeogitOrg/neogit",
  cmd = "Neogit",
  keys = {
    { "<leader>gs", "<cmd>Neogit<CR>", desc = "Neogit status" },
    { "<leader>gc", "<cmd>Neogit commit<CR>", desc = "Neogit commit" },
    { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Diffview open" },
    { "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", desc = "File history" },
    { "<leader>gq", "<cmd>DiffviewClose<CR>", desc = "Diffview close" },
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
