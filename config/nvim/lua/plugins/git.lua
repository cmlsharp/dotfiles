return {
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    opts = {
      on_attach = function(bufnr)
        local gs = require "gitsigns"
        local map = function(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end
        map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
        map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
        map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
        map("n", "<leader>hp", gs.preview_hunk_inline, "Preview hunk inline")
        map("n", "]h", gs.next_hunk, "Next hunk")
        map("n", "[h", gs.prev_hunk, "Prev hunk")
      end,
    },
  },

  {
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
  },

  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Diffview open" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", desc = "File history" },
      { "<leader>gq", "<cmd>DiffviewClose<CR>", desc = "Diffview close" },
    },
    opts = {},
  },

  {
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
  },
}
