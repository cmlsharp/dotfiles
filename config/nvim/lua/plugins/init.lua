return {
  -- Autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
  },

  -- Better escape
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
  },

  -- Rust
  {
    "mrcjkb/rustaceanvim",
    version = "^6",
    ft = "rust",
    keys = {
      { "<leader>Rd", function() vim.cmd.RustLsp("debuggables") end, ft = "rust", desc = "Rust debuggables" },
    },
  },

  -- Haskell
  {
    "mrcjkb/haskell-tools.nvim",
    version = "^6",
    lazy = false,
  },
  {
    "neovimhaskell/haskell-vim",
    ft = "haskell",
  },

  -- DAP (Debug Adapter Protocol)
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        opts = {},
        config = function(_, opts)
          local dapui = require("dapui")
          dapui.setup(opts)
          local dap = require("dap")
          dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
          dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
          dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
        end,
      },
      { "theHamsta/nvim-dap-virtual-text", opts = {} },
      {
        "jay-babu/mason-nvim-dap.nvim",
        opts = {
          ensure_installed = { "codelldb" },
          handlers = {},
        },
      },
    },
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "Continue / Start" },
      { "<S-F5>", function() require("dap").terminate() end, desc = "Terminate" },
      { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
      { "<S-F9>", function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end, desc = "Conditional breakpoint" },
      { "<F10>", function() require("dap").step_over() end, desc = "Step over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Step into" },
      { "<S-F11>", function() require("dap").step_out() end, desc = "Step out" },
      { "<C-F5>", function() require("dap").run_to_cursor() end, desc = "Run to cursor" },
      { "<C-S-F5>", function() require("dap").run_last() end, desc = "Run last" },
      { "<F6>", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      { "<S-F6>", function() require("dapui").toggle() end, desc = "Toggle DAP UI" },
      { "<F8>", function() require("dapui").eval() end, desc = "Eval expression", mode = { "n", "v" } },
      { "<F1>", function()
        local lines = {
          " DAP Cheatsheet ",
          "",
          " F5        Continue / Start",
          " Shift+F5  Terminate",
          " Ctrl+F5   Run to cursor",
          " C-S-F5    Run last",
          "",
          " F9        Toggle breakpoint",
          " Shift+F9  Conditional breakpoint",
          "",
          " F10       Step over",
          " F11       Step into",
          " Shift+F11 Step out",
          "",
          " F6        Toggle REPL",
          " Shift+F6  Toggle DAP UI",
          " F8        Eval expression",
          "",
          " Press any key to close",
        }
        local width = 32
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        local win = vim.api.nvim_open_win(buf, true, {
          relative = "editor",
          width = width,
          height = #lines,
          col = math.floor((vim.o.columns - width) / 2),
          row = math.floor((vim.o.lines - #lines) / 2),
          style = "minimal",
          border = "rounded",
        })
        vim.bo[buf].modifiable = false
        vim.keymap.set("n", "<Esc>", function()
          vim.api.nvim_win_close(win, true)
          vim.keymap.del("n", "<Esc>", { buffer = buf })
        end, { buffer = buf })
        vim.api.nvim_create_autocmd("BufLeave", {
          buffer = buf,
          once = true,
          callback = function() pcall(vim.api.nvim_win_close, win, true) end,
        })
        -- close on any keypress
        vim.defer_fn(function()
          local ok, key = pcall(vim.fn.getcharstr)
          if ok then
            pcall(vim.api.nvim_win_close, win, true)
            -- feed the key back if it's an action key
            if key ~= "\27" then vim.api.nvim_feedkeys(key, "m", false) end
          end
        end, 50)
      end, desc = "DAP cheatsheet" },
    },
  },

  -- Todo comments
  {
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },

  -- Guess indentation
  {
    "NMAC427/guess-indent.nvim",
    event = "BufReadPost",
    opts = {},
  },

  -- Lean
  {
    "Julian/lean.nvim",
    event = { "BufReadPre *.lean", "BufNewFile *.lean" },
    dependencies = { "nvim-lua/plenary.nvim" },
    ---@type lean.Config
    opts = {
      mappings = true,
    },
  },

  -- Idris2
  {
    "idris-community/idris2-nvim",
    event = { "BufReadPre *.idr", "BufNewFile *.idr" },
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      return {
        client = {
          hover = {
            use_split = false,
            split_size = "20%",
            auto_resize_split = true,
            split_position = "bottom",
            with_history = false,
            use_as_popup = false,
          },
        },
        server = {
          capabilities = capabilities,
        },
        autostart_semantic = false,
        code_action_post_hook = function(action) end,
        use_default_semantic_hl_groups = false,
        default_regexp_syntax = true,
      }
    end,
  },

  -- Harpoon
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
  },

  -- Undotree
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
  },

  -- Zokrates
  {
    "blockparty-sh/vim-zokrates",
    ft = "zokrates",
  },

  -- Fidget (LSP progress + notifications)
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {},
  },

  -- Gitsigns
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    branch = "master",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      { "DrKJeff16/project.nvim", config = function() require("project").setup() end },
    },
  },

  -- Treesitter
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      local filetypes = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'rust', 'haskell', 'ocaml', 'cpp' }
      require('nvim-treesitter').install(filetypes)
      vim.api.nvim_create_autocmd('FileType', {
        pattern = filetypes,
        callback = function() vim.treesitter.start() end,
      })
    end,
  },

  -- Treesitter textobjects
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = "VeryLazy",
  },

  -- Treesitter context (sticky function headers)
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      max_lines = 1,
      mode = "cursor",
    },
  },

  -- Flash (jump anywhere in 2-3 keystrokes)
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    },
  },

  -- Surround
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },

  -- Toggleterm
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return math.floor(vim.o.lines * 0.3)
        elseif term.direction == "vertical" then
          return math.floor(vim.o.columns * 0.4)
        end
      end,
      open_mapping = [[<C-\>]],
      direction = "horizontal",
      shade_terminals = false,
      persist_size = false,
      on_open = function(term)
        if term.direction == "horizontal" then
          local target = math.floor(vim.o.lines * 0.3)
          vim.api.nvim_win_set_height(term.window, target)
        end
      end,
    },
  },

  -- Dressing (use Telescope for vim.ui.select)
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- Session manager
  {
    "Shatur/neovim-session-manager",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = false,
    config = function()
      local config = require("session_manager.config")
      require("session_manager").setup({
        autoload_mode = config.AutoloadMode.Disabled,
        autosave_only_in_session = true,
        autosave_ignore_filetypes = { "alpha" },
      })
    end,
  },

  -- Alpha (start screen)
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function()
      local dashboard = require("alpha.themes.dashboard")

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

      dashboard.section.buttons.val = {
        dashboard.button("s", "  " .. last_label, ":SessionManager load_last_session<CR>"),
        dashboard.button("S", "  Sessions", ":SessionManager load_session<CR>"),
        dashboard.button("o", "  Open project", ":lua require('alpha.projects').open()<CR>"),
        dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
        dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
        dashboard.button("q", "  Quit", ":qa<CR>"),
      }
      require("alpha").setup(dashboard.config)
    end,
  },

  -- Conform (format-on-save)
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        rust = { lsp_format = "fallback" },
        ocaml = { lsp_format = "fallback" },
        idris2 = { lsp_format = "fallback" },
      },
      format_on_save = { timeout_ms = 2000, lsp_format = "fallback" },
    },
  },

  -- Mini.ai (enhanced text objects)
  {
    "echasnovski/mini.ai",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },

  -- Avante (AI assistant)
  {
    "yetone/avante.nvim",
    lazy = false,
    version = false,
    build = "make",
    opts = {
      provider = "claude",
      providers = {
        claude = {
          endpoint = "https://api.anthropic.com",
          model = "claude-sonnet-4-20250514",
          extra_request_body = {
            temperature = 0.75,
            max_tokens = 20480,
          },
        },
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      "nvim-telescope/telescope.nvim",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = { file_types = { "markdown", "Avante" } },
        ft = { "markdown", "Avante" },
      },
    },
  },
}
