local opt = vim.opt

opt.number = true
opt.relativenumber = true

opt.shiftwidth = 4
opt.tabstop = 4
opt.expandtab = true

--opt.swapfile = true
--opt.directory = vim.fn.stdpath("cache") .. "/swap"
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

opt.showmode = false
opt.breakindent = true
opt.inccommand = "split"
opt.timeoutlen = 300

opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.confirm = true
opt.lazyredraw = true
opt.smoothscroll = true
opt.backup = false
opt.writebackup = false
