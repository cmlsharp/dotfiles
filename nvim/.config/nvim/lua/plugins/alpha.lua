return {
  "goolord/alpha-nvim",
  enabled = false,
  event = "VimEnter",
  config = function()
    local dashboard = require "alpha.themes.dashboard"

    local project_dirs = {
      "~/Documents/code",
      "~/Documents/research",
    }

    local function open_project(picker)
      picker {
        attach_mappings = function(prompt_bufnr)
          local actions = require "telescope.actions"
          actions.select_default:replace(function()
            local entry = require("telescope.actions.state").get_selected_entry()
            actions.close(prompt_bufnr)
            if not entry then
              return
            end
            vim.cmd("cd " .. vim.fn.fnameescape(entry.value))
            if not require("session_manager").load_current_dir_session() then
              require("telescope.builtin").find_files()
            end
          end)
          return true
        end,
      }
    end

    function _G._alpha_open_project()
      open_project(function(opts)
        opts.search_dirs = project_dirs
        require("telescope").extensions.repo.list(opts)
      end)
    end

    function _G._alpha_open_saved_project()
      open_project(function(opts)
        require("telescope").extensions.projects.projects(opts)
      end)
    end

    local function add_project()
      require("telescope").extensions.repo.list {
        attach_mappings = function(prompt_bufnr, map)
          local actions = require "telescope.actions"
          local action_state = require "telescope.actions.state"
          actions.select_default:replace(function()
            local entry = action_state.get_selected_entry()
            actions.close(prompt_bufnr)
            if not entry then
              return
            end
            vim.cmd("ProjectAdd " .. vim.fn.fnameescape(entry.value))
          end)
          return true
        end,
      }
    end

    -- Build last session label from path
    local last_label = "Last session"
    local ok, utils = pcall(require, "session_manager.utils")
    if ok then
      local last = utils.get_last_session_filename()
      if last then
        local sm_config = require "session_manager.config"
        local dir = tostring(sm_config.session_filename_to_dir(last))
        local short = dir:gsub("^" .. vim.pesc(vim.fn.expand "~"), "~")
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

    vim.keymap.set("n", "<leader>pp", _G._alpha_open_project, { desc = "[P]roject switch" })
    vim.keymap.set("n", "<leader>pa", add_project, { desc = "[P]roject [A]dd" })
    vim.keymap.set("n", "<leader>pd", "<cmd>ProjectDelete<CR>", { desc = "[P]roject [D]elete" })

    dashboard.section.buttons.val = {
      dashboard.button("s", "   " .. last_label, ":SessionManager load_last_session<CR>"),
      dashboard.button("o", "   Open saved project", "<cmd>lua _G._alpha_open_saved_project()<CR>"),
      dashboard.button("n", "   Open new project", "<cmd>lua _G._alpha_open_project()<CR>"),
      dashboard.button("f", "   Find file", ":Telescope find_files<CR>"),
      dashboard.button("r", "   Recent files", ":Telescope oldfiles<CR>"),
      dashboard.button("q", "   Quit", ":qa<CR>"),
    }
    require("alpha").setup(dashboard.config)
  end,
}
