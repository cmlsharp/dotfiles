return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewFileHistory" },
  keys = {
    { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Diffview open" },
    { "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", desc = "File history" },
    { "<leader>gq", "<cmd>DiffviewClose<CR>", desc = "Diffview close" },
  },
  opts = {},
}
