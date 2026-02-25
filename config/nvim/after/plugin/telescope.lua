local ok, telescope = pcall(require, "telescope")
if not ok then
  return
end

telescope.load_extension "fzf"
telescope.load_extension "projects"

local builtin = require "telescope.builtin"
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<C-p>", builtin.git_files, { desc = "Telescope git files" })
vim.keymap.set("n", "<leader>fs", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Telescope diagnostics" })
vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Telescope keymaps" })
vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Telescope recent files" })
vim.keymap.set("n", "<leader>fm", builtin.marks, { desc = "Telescope marks" })
vim.keymap.set("n", "<leader>f\"", builtin.registers, { desc = "Telescope registers" })
vim.keymap.set("n", "<leader>ft", builtin.treesitter, { desc = "Telescope treesitter symbols" })
vim.keymap.set("n", "<leader>fp", telescope.extensions.projects.projects, { desc = "Telescope projects" })
vim.keymap.set("n", "<leader>f.", builtin.resume, { desc = "Telescope resume" })
vim.keymap.set("n", "<leader>fgc", builtin.git_commits, { desc = "Telescope git commits" })
vim.keymap.set("n", "<leader>fgB", builtin.git_bcommits, { desc = "Telescope git buffer commits" })
vim.keymap.set("n", "<leader>fgb", builtin.git_branches, { desc = "Telescope git branches" })

-- LSP
vim.keymap.set("n", "<leader>fi", builtin.lsp_incoming_calls, { desc = "Telescope incoming calls" })
vim.keymap.set("n", "<leader>fO", builtin.lsp_outgoing_calls, { desc = "Telescope outgoing calls" })
vim.keymap.set("n", "gd", builtin.lsp_definitions, { desc = "Telescope definitions" })
vim.keymap.set("n", "gi", builtin.lsp_implementations, { desc = "Telescope implementations" })
vim.keymap.set("n", "gr", builtin.lsp_references, { desc = "Telescope references" })
vim.keymap.set("n", "<leader>D", builtin.lsp_type_definitions, { desc = "Telescope type definitions" })
vim.keymap.set("n", "<leader>fo", builtin.lsp_document_symbols, { desc = "Telescope document symbols" })
vim.keymap.set("n", "<leader>fw", builtin.lsp_dynamic_workspace_symbols, { desc = "Telescope workspace symbols" })
