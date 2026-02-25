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

  -- Gitsigns
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    version = "*",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        "vim", "lua", "vimdoc", "html", "css", "rust", "c", "cpp",
      },
    },
    config = function(_, opts)
      require("nvim-treesitter").setup(opts)
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
}
