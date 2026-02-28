return {
  "Julian/lean.nvim",
  event = { "BufReadPre *.lean", "BufNewFile *.lean" },
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    mappings = true,
  },
  config = function(_, opts)
    require("lean").setup(opts)
    vim.api.nvim_create_autocmd("QuitPre", {
      pattern = "*.lean",
      callback = function()
        -- Count non-infoview windows
        local wins = 0
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].filetype ~= "leaninfo" then
            wins = wins + 1
          end
        end
        -- If this is the last non-infoview window, close the infoview
        -- so that :q actually quits nvim
        if wins <= 1 then
          require("lean.infoview").close()
        end
      end,
    })
  end,
}
