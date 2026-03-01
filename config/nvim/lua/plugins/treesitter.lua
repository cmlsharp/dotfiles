return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    branch = "main",
    config = function()
      local parsers = {
        "bash",
        "c",
        "diff",
        "html",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "query",
        "vim",
        "vimdoc",
        "rust",
        "haskell",
        "ocaml",
        "cpp",
      }
      require("nvim-treesitter").install(parsers)
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local buf, filetype = args.buf, args.match

          local language = vim.treesitter.language.get_lang(filetype)
          if not language then
            return
          end

          if not vim.treesitter.language.add(language) then
            return
          end

          vim.treesitter.start(buf, language)
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = "VeryLazy",
    config = function()
      require("nvim-treesitter-textobjects").setup {
        select = { lookahead = true },
        move = { set_jumps = true },
      }

      local function attach(buf)
        local select_fn = require("nvim-treesitter-textobjects.select").select_textobject
        local move = require("nvim-treesitter-textobjects.move")
        local swap = require("nvim-treesitter-textobjects.swap")
        local function opts(desc) return { buffer = buf, desc = desc } end

        -- Select
        vim.keymap.set({ "x", "o" }, "af", function() select_fn("@function.outer", "textobjects") end, opts("Select outer function"))
        vim.keymap.set({ "x", "o" }, "if", function() select_fn("@function.inner", "textobjects") end, opts("Select inner function"))
        vim.keymap.set({ "x", "o" }, "ac", function() select_fn("@class.outer", "textobjects") end, opts("Select outer class"))
        vim.keymap.set({ "x", "o" }, "ic", function() select_fn("@class.inner", "textobjects") end, opts("Select inner class"))
        vim.keymap.set({ "x", "o" }, "aa", function() select_fn("@parameter.outer", "textobjects") end, opts("Select outer argument"))
        vim.keymap.set({ "x", "o" }, "ia", function() select_fn("@parameter.inner", "textobjects") end, opts("Select inner argument"))

        -- Move
        vim.keymap.set({ "n", "x", "o" }, "]f", function() move.goto_next_start("@function.outer", "textobjects") end, opts("Next function start"))
        vim.keymap.set({ "n", "x", "o" }, "]a", function() move.goto_next_start("@parameter.outer", "textobjects") end, opts("Next argument start"))
        vim.keymap.set({ "n", "x", "o" }, "]F", function() move.goto_next_end("@function.outer", "textobjects") end, opts("Next function end"))
        vim.keymap.set({ "n", "x", "o" }, "[f", function() move.goto_previous_start("@function.outer", "textobjects") end, opts("Prev function start"))
        vim.keymap.set({ "n", "x", "o" }, "[a", function() move.goto_previous_start("@parameter.outer", "textobjects") end, opts("Prev argument start"))
        vim.keymap.set({ "n", "x", "o" }, "[F", function() move.goto_previous_end("@function.outer", "textobjects") end, opts("Prev function end"))

        -- Swap (gs = "go swap", avoids collision with <leader>s Search namespace)
        vim.keymap.set("n", "gsa", function() swap.swap_next("@parameter.inner") end, opts("Swap with next argument"))
        vim.keymap.set("n", "gsA", function() swap.swap_previous("@parameter.inner") end, opts("Swap with prev argument"))
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter_textobjects", { clear = true }),
        callback = function(ev) attach(ev.buf) end,
      })
      -- Attach to already-open buffers
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) then attach(buf) end
      end
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      max_lines = 1,
      mode = "cursor",
    },
  },
}
