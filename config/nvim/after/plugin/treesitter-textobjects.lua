local ok, ts_textobjects = pcall(require, "nvim-treesitter-textobjects")
if not ok then
  return
end

ts_textobjects.setup {
  select = { lookahead = true },
  move = { set_jumps = true },
}

local function attach(buf)
  local select_fn = require("nvim-treesitter-textobjects.select").select_textobject
  local move = require("nvim-treesitter-textobjects.move")
  local swap = require("nvim-treesitter-textobjects.swap")
  local opts = function(desc) return { buffer = buf, desc = desc } end

  -- Select
  vim.keymap.set({ "x", "o" }, "af", function() select_fn("@function.outer", "textobjects") end, opts("Select outer function"))
  vim.keymap.set({ "x", "o" }, "if", function() select_fn("@function.inner", "textobjects") end, opts("Select inner function"))
  vim.keymap.set({ "x", "o" }, "ac", function() select_fn("@class.outer", "textobjects") end, opts("Select outer class"))
  vim.keymap.set({ "x", "o" }, "ic", function() select_fn("@class.inner", "textobjects") end, opts("Select inner class"))
  vim.keymap.set({ "x", "o" }, "aa", function() select_fn("@parameter.outer", "textobjects") end, opts("Select outer argument"))
  vim.keymap.set({ "x", "o" }, "ia", function() select_fn("@parameter.inner", "textobjects") end, opts("Select inner argument"))

  -- Move
  vim.keymap.set({ "n", "x", "o" }, "]f", function() move.goto_next_start("@function.outer", "textobjects") end, opts("Next function start"))
  vim.keymap.set({ "n", "x", "o" }, "]a", function() move.goto_next_start("@parameter.outer", "textobjects") end, opts("Next argument start"))
  vim.keymap.set({ "n", "x", "o" }, "]F", function() move.goto_next_end("@function.outer", "textobjects") end, opts("Next function end"))
  vim.keymap.set({ "n", "x", "o" }, "[f", function() move.goto_previous_start("@function.outer", "textobjects") end, opts("Prev function start"))
  vim.keymap.set({ "n", "x", "o" }, "[a", function() move.goto_previous_start("@parameter.outer", "textobjects") end, opts("Prev argument start"))
  vim.keymap.set({ "n", "x", "o" }, "[F", function() move.goto_previous_end("@function.outer", "textobjects") end, opts("Prev function end"))

  -- Swap
  vim.keymap.set("n", "<leader>sa", function() swap.swap_next("@parameter.inner") end, opts("Swap with next argument"))
  vim.keymap.set("n", "<leader>sA", function() swap.swap_previous("@parameter.inner") end, opts("Swap with prev argument"))
end

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("treesitter_textobjects", { clear = true }),
  callback = function(ev) attach(ev.buf) end,
})
-- Attach to already-open buffers
for _, buf in ipairs(vim.api.nvim_list_bufs()) do
  if vim.api.nvim_buf_is_loaded(buf) then attach(buf) end
end
