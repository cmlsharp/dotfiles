return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    config = function()
      require("catppuccin").setup {}
      vim.cmd.colorscheme "catppuccin"
      vim.api.nvim_set_hl(0, "TreesitterContext", { link = "Normal" })
      vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { link = "Normal" })
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "catppuccin",
      },
    },
  },

  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        custom_filter = function(buf)
          return vim.bo[buf].buftype ~= "terminal"
        end,
      },
    },
  },

  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function()
      local dashboard = require "alpha.themes.dashboard"

      local function open_project()
        require("telescope").extensions.projects.projects {}
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

      vim.keymap.set("n", "<leader>pp", open_project, { desc = "[P]roject switch" })
      vim.keymap.set("n", "<leader>pa", add_project, { desc = "[P]roject [A]dd" })
      vim.keymap.set("n", "<leader>pd", "<cmd>ProjectDelete<CR>", { desc = "[P]roject [D]elete" })

      dashboard.section.buttons.val = {
        dashboard.button("s", "  " .. last_label, ":SessionManager load_last_session<CR>"),
        dashboard.button("O", "  Open project", ":Telescope projects<CR>"),
        dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
        dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
        dashboard.button("q", "  Quit", ":qa<CR>"),
      }
      require("alpha").setup(dashboard.config)
    end,
  },

  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    opts = {},
  },

  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {},
  },

  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {},
  },

  {
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
        { "<leader>p", group = "[P]roject" },
        { "<leader>t", group = "[T]oggle" },
        { "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
        { "gr", group = "LSP Actions", mode = { "n" } },
      },
    },
  },
}
