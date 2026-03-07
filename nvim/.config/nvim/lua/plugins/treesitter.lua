return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufRead", "BufNewFile" },
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
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
      },
      highlight = { enable = true },
      indent = { enable = true, disable = { "ocaml" } },
    })
  end,
}
