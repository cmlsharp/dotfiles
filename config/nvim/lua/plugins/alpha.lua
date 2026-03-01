return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  config = function()
    local dashboard = require("alpha.themes.dashboard")

    local function open_project()
      local actions = require "telescope.actions"
      local action_state = require "telescope.actions.state"
      local pickers = require "telescope.pickers"
      local finders = require "telescope.finders"
      local conf = require("telescope.config").values

      pickers
        .new({}, {
          prompt_title = "Open Project",
          finder = finders.new_oneshot_job(
            { "fd", "--type", "d", "--hidden", "--exclude", ".git", ".", vim.fn.expand "~" },
            {}
          ),
          sorter = conf.generic_sorter {},
          attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
              local entry = action_state.get_selected_entry()
              actions.close(prompt_bufnr)
              if not entry or not entry[1] then
                return
              end

              local dir = entry[1]
              vim.cmd("cd " .. vim.fn.fnameescape(dir))

              local sm = require "session_manager"
              if not sm.load_current_dir_session() then
                sm.save_current_session()
                require("telescope.builtin").find_files()
              end
            end)
            return true
          end,
        })
        :find()
    end

    -- Build last session label from path
    local last_label = "Last session"
    local ok, utils = pcall(require, "session_manager.utils")
    if ok then
      local last = utils.get_last_session_filename()
      if last then
        local sm_config = require("session_manager.config")
        local dir = tostring(sm_config.session_filename_to_dir(last))
        local short = dir:gsub("^" .. vim.pesc(vim.fn.expand("~")), "~")
        if #short <= 30 then
          last_label = "Last session (" .. short .. ")"
        else
          local parts = vim.split(dir, "/", { trimempty = true })
          local n = #parts
          if n >= 2 then
            last_label = "Last session (../" .. parts[n - 1] .. "/" .. parts[n] .. ")"
          elseif n >= 1 then
            last_label = "Last session (../" .. parts[n] .. ")"
          end
        end
      end
    end

    -- Register as a keymap so dashboard.button can reference it
    vim.keymap.set("n", "<leader>o", open_project, { desc = "Open project" })

    dashboard.section.buttons.val = {
      dashboard.button("s", "  " .. last_label, ":SessionManager load_last_session<CR>"),
      dashboard.button("S", "  Sessions", ":SessionManager load_session<CR>"),
      dashboard.button("o", "  Open project", "<leader>o"),
      dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
      dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
      dashboard.button("q", "  Quit", ":qa<CR>"),
    }
    require("alpha").setup(dashboard.config)
  end,
}
