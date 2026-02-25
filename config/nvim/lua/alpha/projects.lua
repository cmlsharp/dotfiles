local M = {}

--- Fuzzy-find a directory from ~/ and open it as a project
function M.open()
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values

  pickers.new({}, {
    prompt_title = "Open Project",
    finder = finders.new_oneshot_job(
      { "fd", "--type", "d", "--hidden", "--exclude", ".git", ".", vim.fn.expand("~") },
      {}
    ),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local entry = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if not entry or not entry[1] then
          return
        end

        local dir = entry[1]
        vim.cmd("cd " .. vim.fn.fnameescape(dir))

        local sm = require("session_manager")
        if not sm.load_current_dir_session() then
          sm.save_current_session()
          require("telescope.builtin").find_files()
        end
      end)
      return true
    end,
  }):find()
end

return M
