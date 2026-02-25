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
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

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

  -- Conform
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
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
      local filetypes = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'rust', 'haskell', 'ocaml' }
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

  -- Surround
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },

  -- Multicursor
  {
    "jake-stewart/multicursor.nvim",
    event = "VeryLazy",
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
      "stevearc/dressing.nvim",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = { file_types = { "markdown", "Avante" } },
        ft = { "markdown", "Avante" },
      },
    },
  },
}
