local ok, gs = pcall(require, "gitsigns")
if not ok then
  return
end

gs.setup {
  on_attach = function(bufnr)
    local map = function(mode, l, r, desc)
      vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
    end
    map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
    map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
    map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
    map("n", "<leader>hp", gs.preview_hunk_inline, "Preview hunk inline")
    map("n", "]h", gs.next_hunk, "Next hunk")
    map("n", "[h", gs.prev_hunk, "Prev hunk")
  end,
}
