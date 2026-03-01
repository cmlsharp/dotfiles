local map = vim.keymap.set

map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })

-- Window navigation
map("", "<A-h>", "<C-\\><C-n><C-w>h")
map("", "<A-j>", "<C-\\><C-n><C-w>j")
map("", "<A-k>", "<C-\\><C-n><C-w>k")
map("", "<A-l>", "<C-\\><C-n><C-w>l")

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

map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")
map("n", "J", "mzJ`z")

map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

map("n", "<leader>y", '"+y')
map("v", "<leader>y", '"+y')
map("n", "<leader>Y", '"+Y')
map("n", "<leader>p", '"+p')
map("x", "<leader>p", [["_dP]])
map({ "n", "v" }, "<leader>d", [["_d]])

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
map("n", "<leader>lj", "<cmd>cnext<CR>zz")
map("n", "<leader>lk", "<cmd>cprev<CR>zz")
map("n", "<leader>ln", "<cmd>lnext<CR>zz", { desc = "Next location list item" })
map("n", "<leader>lp", "<cmd>lprev<CR>zz", { desc = "Prev location list item" })

map("n", "Q", "@q", { desc = "Replay last macro" })
map("n", "ZZ", "<cmd>wq<CR>", { desc = "Save and quit all" })
map("n", "ZQ", "<cmd>q<CR>", { desc = "Quit all" })

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
