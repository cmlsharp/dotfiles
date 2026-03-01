local map = vim.keymap.set

map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = "Down (visual line)" })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = "Up (visual line)" })

-- Window navigation
map("", "<A-h>", "<C-\\><C-n><C-w>h", { desc = "Window left" })
map("", "<A-j>", "<C-\\><C-n><C-w>j", { desc = "Window down" })
map("", "<A-k>", "<C-\\><C-n><C-w>k", { desc = "Window up" })
map("", "<A-l>", "<C-\\><C-n><C-w>l", { desc = "Window right" })

-- Clear search highlight
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "Clear search highlight" })

-- Buffer navigation
map("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" })
map("n", "<leader>x", "<cmd>bdelete<CR>", { desc = "Close buffer" })

-- NvimTree
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file tree" })

-- Terminal
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Better paste in visual mode (don't yank replaced text)
map("x", "<leader>p", [["_dP]], { desc = "Paste without yanking" })

map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
map("n", "J", "mzJ`z", { desc = "Join lines (keep cursor)" })

map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centered)" })

map("n", "<leader>y", '"+y', { desc = "Yank to clipboard" })
map("v", "<leader>y", '"+y', { desc = "Yank to clipboard" })
map("n", "<leader>Y", '"+Y', { desc = "Yank line to clipboard" })
map("n", "<leader>p", '"+p', { desc = "Paste from clipboard" })
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete to black hole" })

-- quickfix list
map("n", "<leader>q", function()
  local wins = vim.fn.getwininfo()
  for _, win in ipairs(wins) do
    if win.quickfix == 1 then
      vim.cmd "cclose"
      return
    end
  end
  vim.cmd "copen"
end, { desc = "Toggle quickfix list" })
map("n", "]q", "<cmd>cnext<CR>zz", { desc = "Next quickfix item" })
map("n", "[q", "<cmd>cprev<CR>zz", { desc = "Prev quickfix item" })
map("n", "]l", "<cmd>lnext<CR>zz", { desc = "Next location list item" })
map("n", "[l", "<cmd>lprev<CR>zz", { desc = "Prev location list item" })

map("n", "Q", "@q", { desc = "Replay last macro" })
map("n", "ZZ", "<cmd>wq<CR>", { desc = "Save and quit" })
map("n", "ZQ", "<cmd>q<CR>", { desc = "Quit" })

-- Diagnostics
map("n", "<leader>k", function()
  vim.diagnostic.config { virtual_lines = { current_line = true }, virtual_text = false }

  vim.api.nvim_create_autocmd("CursorMoved", {
    group = vim.api.nvim_create_augroup("line-diagnostics", { clear = true }),
    callback = function()
      vim.diagnostic.config { virtual_lines = false, virtual_text = true }
      return true
    end,
  })
end, { desc = "Toggle diagnostic virtual lines" })

map("n", "<leader>e", function()
  vim.diagnostic.open_float(nil, {
    border = "rounded",
    max_width = 80,
    wrap = true,
  })
end, { desc = "Diagnostic float" })
