vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.expandtab = true
vim.opt_local.commentstring = "-- %s"

-- Idris2-specific keybindings for interactive editing
local code_action = require('idris2.code_action')
local metavars = require('idris2.metavars')
local hover = require('idris2.hover')
local browse = require('idris2.browse')
local repl = require('idris2.repl')

local bufnr = vim.api.nvim_get_current_buf()
local def = { noremap = true, silent = true, buffer = bufnr }
local function opts(desc) return vim.tbl_extend("force", def, { desc = desc }) end

-- Helper function to save before running action
-- check_modified: if true, only save if buffer is modified; if false, always save
local function save_and_run(action, check_modified)
  if check_modified == nil then check_modified = true end
  return function()
    if check_modified then
      if vim.api.nvim_get_option_value('modified', { buf = 0 }) then
        vim.cmd('write')
      end
    else
      vim.cmd('write')
    end
    action()
  end
end

-- Code Actions (always save since they modify the file)
vim.keymap.set('n', '<leader>ic', save_and_run(code_action.case_split, false), opts("Case split"))
vim.keymap.set('n', '<leader>ia', save_and_run(code_action.add_clause, false), opts("Add clause"))
vim.keymap.set('n', '<leader>ie', save_and_run(code_action.expr_search, false), opts("Expression search"))
vim.keymap.set('n', '<leader>ig', save_and_run(code_action.generate_def, false), opts("Generate definition"))
vim.keymap.set('n', '<leader>ir', save_and_run(code_action.refine_hole, false), opts("Refine hole"))
vim.keymap.set('n', '<leader>imc', save_and_run(code_action.make_case, false), opts("Make case"))
vim.keymap.set('n', '<leader>iml', save_and_run(code_action.make_lemma, false), opts("Make lemma"))
vim.keymap.set('n', '<leader>imw', save_and_run(code_action.make_with, false), opts("Make with"))

-- Metavariable Navigation (auto-save before running)
vim.keymap.set('n', '<leader>imn', save_and_run(metavars.goto_next), opts("Next metavar"))
vim.keymap.set('n', '<leader>imp', save_and_run(metavars.goto_prev), opts("Prev metavar"))
vim.keymap.set('n', '<leader>ima', save_and_run(metavars.request_all), opts("List all metavars"))

-- Hover and Type Info (always save to ensure LSP has latest state)
vim.keymap.set('n', 'K', function() hover.hover (false) end, opts("Hover"))
vim.keymap.set('n', '<leader>it', save_and_run(function() hover.hover(true) end, false), opts("Type info (split)"))

-- Auto-updating hover in split
local hover_autocmd_id = nil
local function toggle_auto_hover()
  if hover_autocmd_id then
    vim.api.nvim_del_autocmd(hover_autocmd_id)
    hover_autocmd_id = nil
    vim.notify("Auto-hover disabled", vim.log.levels.INFO)
  else
    -- Open split first
    hover.hover(true)
    -- Set up autocmd to update on cursor hold
    hover_autocmd_id = vim.api.nvim_create_autocmd({"CursorHold"}, {
      buffer = bufnr,
      callback = function()
        if vim.api.nvim_get_option_value('modified', { buf = 0 }) then
          vim.cmd('write')
        end
        hover.hover(true)
      end
    })
    vim.notify("Auto-hover enabled (updates on cursor hold)", vim.log.levels.INFO)
  end
end
vim.keymap.set('n', '<leader>ita', toggle_auto_hover, opts("Toggle auto-hover"))

-- Browse and REPL (auto-save before running)
vim.keymap.set('n', '<leader>ib', save_and_run(browse.browse), opts("Browse namespace"))
vim.keymap.set('n', '<leader>ix', save_and_run(repl.evaluate), opts("Evaluate in REPL"))

-- Semantic highlighting refresh (auto-save before running)
vim.keymap.set('n', '<leader>ish', save_and_run(function()
  vim.lsp.buf_request(bufnr, 'workspace/semanticTokens/refresh', {})
end), opts("Refresh semantic highlights"))

-- Auto-enable hover on file open
--vim.defer_fn(function()
--  if not hover_autocmd_id then
--    toggle_auto_hover()
--  end
--end, 100)
