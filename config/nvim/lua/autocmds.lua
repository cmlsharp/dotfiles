local augroup = vim.api.nvim_create_augroup("UserGroup", {})

-- Restore cursor position on file open
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
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

-- LSP format on save for specific filetypes
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  pattern = { "*.rs", "*.ml", "*.idr" },
  callback = function()
    vim.lsp.buf.format { async = false }
  end,
})
