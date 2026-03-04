local augroup = vim.api.nvim_create_augroup("UserGroup", {})

vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup,
  callback = function()
    local current_tab = vim.api.nvim_get_current_tabpage()
    vim.cmd "tabdo wincmd ="
    vim.api.nvim_set_current_tabpage(current_tab)
  end,
  desc = "Resize splits with terminal window",
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  desc = "Close read-only buffer with q/esc",
  pattern = {
    "help",
    "startuptime",
    "qf",
    "lspinfo",
    "man",
    "checkhealth",
    "neotest-output-panel",
    "neotest-summary",
    "lazy",
  },
  callback = function(event)
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = event.buf, silent = true })
    vim.keymap.set("n", "<ESC>", "<cmd>close<CR>", { buffer = event.buf, silent = true })
    vim.bo[event.buf].buflisted = false
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Autocreate a dir when saving a file",
  group = augroup,
  callback = function(event)
    if event.match:match "^%w%w+:[\\/][\\/]" then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  desc = "Delete trailing whitsespace on buf write",
  callback = function()
    local save_cursor = vim.fn.getpos "."
    vim.cmd [[%s/\s\+$//e]]
    vim.fn.setpos(".", save_cursor)
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  desc = "Restore cursor position on file open",
  callback = function(args)
    local mark = vim.fn.line "'\""
    local last = vim.fn.line "$"
    local valid_line = mark >= 1 and mark < last
    local not_commit = vim.b[args.buf].filetype ~= "commit"

    if valid_line and not_commit then
      vim.cmd [[normal! g`"]]
    end
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  desc = "Highlight yanked text",
  callback = function()
    vim.highlight.on_yank()
  end,
})
