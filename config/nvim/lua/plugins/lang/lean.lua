return {
  "Julian/lean.nvim",
  event = { "BufReadPre *.lean", "BufNewFile *.lean" },
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    mappings = true,
  },
  --config = function(_, opts)
  --  require("lean").setup(opts)

  --  -- When quitting a lean buffer, close the infoview so it doesn't
  --  -- strand a winfixbuf window that blocks buffer navigation.
  --  vim.api.nvim_create_autocmd("QuitPre", {
  --    group = vim.api.nvim_create_augroup("LeanInfoviewClose", { clear = true }),
  --    pattern = "*.lean",
  --    callback = function()
  --      require("lean.infoview").close()
  --    end,
  --  })
  --end,
}
