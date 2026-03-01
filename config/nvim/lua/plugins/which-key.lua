return {
  "folke/which-key.nvim",
  event = "VimEnter",
  ---@module 'which-key'
  ---@type wk.Opts
  ---@diagnostic disable-next-line: missing-fields
  opts = {
    -- delay between pressing a key and opening which-key (milliseconds)
    delay = 0,
    icons = { mappings = vim.g.have_nerd_font },

    -- Document existing key chains
    spec = {
      { "<leader>s", group = "[S]earch", mode = { "n", "v" } },
      { "<leader>sg", group = "[S]earch [G]it" },
      { "<leader>g", group = "[G]it" },
      { "<leader>gp", group = "Git [P]R" },
      { "<leader>gi", group = "Git [I]ssue" },
      { "<leader>t", group = "[T]oggle" },
      { "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
      { "gr", group = "LSP Actions", mode = { "n" } },
    },
  },
}
