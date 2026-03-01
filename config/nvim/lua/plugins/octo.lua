return {
  "pwntester/octo.nvim",
  cmd = "Octo",
  keys = {
    { "<leader>gpl", "<cmd>Octo pr list<CR>", desc = "List PRs" },
    { "<leader>gpc", "<cmd>Octo pr create<CR>", desc = "Create PR" },
    { "<leader>gil", "<cmd>Octo issue list<CR>", desc = "List issues" },
    { "<leader>gic", "<cmd>Octo issue create<CR>", desc = "Create issue" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {},
}
