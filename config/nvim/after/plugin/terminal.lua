-- Auto-bootstrap session for projects opened via command line args
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.defer_fn(function()
      if vim.fn.argc() == 0 then
        return
      end

      -- If in a project, save a session so autosave works on exit
      local root = require("project").get_project_root()
      if root then
        require("session_manager").save_current_session()
      end
    end, 100)
  end,
})
