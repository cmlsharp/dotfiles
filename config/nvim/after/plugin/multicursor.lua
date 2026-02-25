local ok, mc = pcall(require, "multicursor-nvim")
if not ok then
  return
end

mc.setup()

local map = vim.keymap.set

-- Add or skip cursor up/down
map({ "n", "v" }, "<C-Up>", function() mc.lineAddCursor(-1) end, { desc = "Add cursor above" })
map({ "n", "v" }, "<C-Down>", function() mc.lineAddCursor(1) end, { desc = "Add cursor below" })

-- Add cursor on next/prev match of word or selection
map({ "n", "v" }, "<C-s>", function() mc.matchAddCursor(1) end, { desc = "Add cursor on next match" })
map({ "n", "v" }, "<C-S-s>", function() mc.matchSkipCursor(1) end, { desc = "Skip and add cursor on next match" })

-- Rotate through cursors
map({ "n", "v" }, "<C-Left>", mc.prevCursor, { desc = "Prev cursor" })
map({ "n", "v" }, "<C-Right>", mc.nextCursor, { desc = "Next cursor" })

-- Clear all cursors
map("n", "<Esc>", function()
  if not mc.cursorsEnabled() then
    mc.enableCursors()
  elseif mc.hasCursors() then
    mc.clearCursors()
  else
    vim.cmd("noh")
  end
end, { desc = "Clear cursors or search highlight" })
