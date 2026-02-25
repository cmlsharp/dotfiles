local opt = vim.opt

opt.number = true
opt.relativenumber = true

opt.shiftwidth = 4
opt.tabstop = 4
opt.expandtab = true

opt.swapfile = true
opt.directory = vim.fn.stdpath("cache") .. "/swap"
opt.undofile = true
opt.undodir = vim.fn.stdpath("cache") .. "/undo"

opt.clipboard = ""

opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true

opt.smartcase = true
opt.ignorecase = true

opt.splitright = true
opt.splitbelow = true

opt.scrolloff = 8
opt.updatetime = 250
opt.mouse = "a"
