return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local filetypes = { "bash", "c", "diff", "html", "lua", "luadoc", "markdown", "markdown_inline", "query", "vim", "vimdoc", "rust", "haskell", "ocaml", "cpp" }
      require("nvim-treesitter").install(filetypes)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = filetypes,
        callback = function() vim.treesitter.start() end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = "VeryLazy",
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
