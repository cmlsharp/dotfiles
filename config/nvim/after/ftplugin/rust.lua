vim.keymap.set("n", "<leader>Rd", function()
  vim.cmd.RustLsp "debuggables"
end, { buffer = true, desc = "Rust debuggables" })
