return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  event = { "BufRead", "BufNewFile" },
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup()
    require("nvim-treesitter").install {
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
      "swift",
      "latex",
      "yaml",
      "typst",
    }
  end,
}
