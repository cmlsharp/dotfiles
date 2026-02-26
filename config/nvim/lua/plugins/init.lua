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
