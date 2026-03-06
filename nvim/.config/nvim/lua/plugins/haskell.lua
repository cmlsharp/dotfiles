return {
  {
    "mrcjkb/haskell-tools.nvim",
    ft = "haskell",

    config = function()
      local ht = require "haskell-tools"
      local function opts(desc)
        return vim.tbl_extend(
          "force",
          { noremap = true, silent = true, buffer = vim.api.nvim_get_current_buf() },
          { desc = desc }
        )
      end
      -- haskell-language-server relies heavily on codeLenses,
      -- so auto-refresh (see advanced configuration) is enabled by default
      vim.keymap.set("n", "<space>cl", vim.lsp.codelens.run, opts "Run codelens")
      -- Hoogle search for the type signature of the definition under the cursor
      vim.keymap.set("n", "<space>hs", ht.hoogle.hoogle_signature, opts "Hoogle signature")
      -- Evaluate all code snippets
      vim.keymap.set("n", "<space>ea", ht.lsp.buf_eval_all, opts "Evaluate all snippets")
      -- Toggle a GHCi repl for the current package
      vim.keymap.set("n", "<leader>rr", ht.repl.toggle, opts "Toggle GHCi REPL (package)")
      -- Toggle a GHCi repl for the current buffer
      vim.keymap.set("n", "<leader>rf", function()
        ht.repl.toggle(vim.api.nvim_buf_get_name(0))
      end, opts "Toggle GHCi REPL (buffer)")
      vim.keymap.set("n", "<leader>rq", ht.repl.quit, opts "Quit GHCi REPL")
    end,
  },
}
