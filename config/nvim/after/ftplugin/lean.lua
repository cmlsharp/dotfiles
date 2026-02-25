-- Lean filetype settings

-- Set maximum line length to 100 characters
vim.opt_local.textwidth = 100
vim.opt_local.colorcolumn = "100"

-- Remove backtick pairing for Lean buffers
local ok, npairs = pcall(require, "nvim-autopairs")
if ok then
  npairs.remove_rule("`")
end

-- Trim trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  buffer = 0,
  callback = function()
    -- Save cursor position
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    -- Remove trailing whitespace
    vim.cmd([[%s/\s\+$//e]])
    -- Restore cursor position
    vim.api.nvim_win_set_cursor(0, cursor_pos)
  end,
})
