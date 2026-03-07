return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "mason.nvim",
    "mason-lspconfig.nvim",
  },
  config = function()
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspKeymaps", {}),
      callback = function(ev)
        local map = vim.keymap.set

        map("n", "grD", vim.lsp.buf.declaration, { buffer = ev.buf, desc = "Go to declaration" })
        map("n", "K", vim.lsp.buf.hover, { buffer = ev.buf, desc = "Hover" })
        map("n", "grn", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename symbol" })
        map({ "n", "v" }, "gra", vim.lsp.buf.code_action, { buffer = ev.buf, desc = "Code action" })
        map("n", "<C-k>", vim.lsp.buf.signature_help, { buffer = ev.buf, desc = "Signature help" })
        map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { buffer = ev.buf, desc = "Add workspace folder" })
        map(
          "n",
          "<leader>wr",
          vim.lsp.buf.remove_workspace_folder,
          { buffer = ev.buf, desc = "Remove workspace folder" }
        )
        map("n", "[d", function()
          vim.diagnostic.jump { jump = -1, float = true }
        end, { buffer = ev.buf, desc = "Prev diagnostic" })
        map("n", "[d", function()
          vim.diagnostic.jump { jump = 1, float = true }
        end, { buffer = ev.buf, desc = "Next diagnostic" })
        map("n", "[e", function()
          vim.diagnostic.jump { jump = -1, float = true, severity = vim.diagnostic.severity.ERROR }
        end, { buffer = ev.buf, desc = "Prev error" })
        map("n", "]e", function()
          vim.diagnostic.jump { jump = 1, float = true, severity = vim.diagnostic.severity.ERROR }
        end, { buffer = ev.buf, desc = "Next error" })

        -- Document highlight on CursorHold
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client and client:supports_method("textDocument/documentHighlight", ev.buf) then
          local hl_group = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = ev.buf,
            group = hl_group,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = ev.buf,
            group = hl_group,
            callback = vim.lsp.buf.clear_references,
          })
          vim.api.nvim_create_autocmd("LspDetach", {
            group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
            callback = function(ev2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = "lsp-highlight", buffer = ev2.buf }
            end,
          })
        end

        -- Inlay hints toggle
        if client and client:supports_method("textDocument/inlayHint", ev.buf) then
          map("n", "<leader>th", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = ev.buf })
          end, { buffer = ev.buf, desc = "Toggle inlay hints" })
        end
      end,
    })

    -- Diagnostic config
    vim.diagnostic.config {
      severity_sort = true,
      float = { border = "rounded", source = "if_many" },
      virtual_text = true,
      jump = { float = true },
    }

    -- Source - https://stackoverflow.com/a/79656109
    -- Posted by Jo Totland
    -- Retrieved 2026-03-04, License - CC BY-SA 4.0

    local blink_ok, blink = pcall(require, "blink.cmp")
    if blink_ok then
      vim.lsp.config("*", {
        capabilities = blink.get_lsp_capabilities(),
      })
    end

    vim.lsp.config("clangd", {
      cmd = {
        "clangd",
        "--background-index", -- index project in background, persist to disk
        "--clang-tidy", -- enable clang-tidy diagnostics
        "--all-scopes-completion", -- suggest symbols from all namespaces, not just visible ones
        "--completion-style=detailed", -- show full type info per overload instead of bundling
        "--header-insertion=iwyu", -- auto-insert #include for used symbols
        "--pch-storage=memory", -- keep precompiled headers in memory (faster, more RAM)
      },
    })

    vim.lsp.config("sourcekit", {
      cmd = { "sourcekit-lsp" },
      filetypes = { "swift" },
    })

    vim.lsp.enable "sourcekit"

    vim.lsp.config("texlab", {
      settings = {
        texlab = {
          build = { onSave = false },
        },
      },
    })
  end,
}
