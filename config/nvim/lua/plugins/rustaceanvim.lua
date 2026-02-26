return {
  "mrcjkb/rustaceanvim",
  version = "^6",
  ft = "rust",
  keys = {
    { "<leader>Rd", function() vim.cmd.RustLsp("debuggables") end, ft = "rust", desc = "Rust debuggables" },
  },
}
