return {
  "Julian/lean.nvim",
  event = { "BufReadPre *.lean", "BufNewFile *.lean" },
  dependencies = { "nvim-lua/plenary.nvim" },
  ---@type lean.Config
  opts = {
    mappings = true,
  },
}
