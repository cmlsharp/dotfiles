return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local npairs = require("nvim-autopairs")
      npairs.setup {}

      -- Disable single quote pairing for OCaml
      local rule = npairs.get_rule("'")
      if rule and rule[1] then
        rule[1].not_filetypes = { "ocaml" }
      end
    end,
  },

  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },

  {
    "echasnovski/mini.ai",
    version = "*",
    event = "VeryLazy",
    opts = { n_lines = 500 },
  },

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

  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    opts = {
      mappings = {
        c = { j = { k = false } },
        t = { j = { k = false } },
        v = { j = { k = false } },
        s = { j = { k = false } },
      },
    },
  },

  {
    "NMAC427/guess-indent.nvim",
    event = "BufReadPost",
    opts = {},
  },

  {
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },

  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<leader><F5>", "<cmd>UndotreeToggle<CR>", desc = "Toggle undotree" },
    },
  },

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
}
