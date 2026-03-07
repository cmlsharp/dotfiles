vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.expandtab = true

-- Use ocp-indent for indentation instead of treesitter
vim.cmd("source " .. vim.fn.expand("~/.opam/default/share/ocp-indent/vim/indent/ocaml.vim"))
