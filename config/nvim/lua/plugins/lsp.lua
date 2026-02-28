return {
  -- LSP
  {
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
          local opts = { buffer = ev.buf }
          local map = vim.keymap.set

          map("n", "gD", vim.lsp.buf.declaration, opts)
          map("n", "K", vim.lsp.buf.hover, opts)
          map("n", "grn", vim.lsp.buf.rename, opts)
          map({ "n", "v" }, "gra", vim.lsp.buf.code_action, opts)
          map("n", "<C-k>", vim.lsp.buf.signature_help, opts)
          map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
          map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
          map("n", "[d", vim.diagnostic.goto_prev, opts)
          map("n", "]d", vim.diagnostic.goto_next, opts)

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

      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      vim.lsp.config("clangd", {
        cmd = {
          "clangd",
          "--background-index",        -- index project in background, persist to disk
          "--clang-tidy",              -- enable clang-tidy diagnostics
          "--all-scopes-completion",   -- suggest symbols from all namespaces, not just visible ones
          "--completion-style=detailed", -- show full type info per overload instead of bundling
          "--header-insertion=iwyu",   -- auto-insert #include for used symbols
          "--pch-storage=memory",      -- keep precompiled headers in memory (faster, more RAM)
        },
      })

      vim.lsp.config("ocamllsp", {
        cmd = { "ocamllsp" },
        filetypes = { "ml", "ocaml", "ocaml.menhir", "ocaml.interface", "ocaml.ocamllex", "reason", "dune" },
      })

      vim.lsp.config("texlab", {
        settings = {
          texlab = {
            build = { onSave = false },
          },
        },
      })

      vim.lsp.enable("ocamllsp")
    end,
  },

  -- Mason
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    opts = {},
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason.nvim", "nvim-lspconfig" },
    opts = {
      ensure_installed = { "html", "cssls", "clangd", "texlab" },
      automatic_enable = {
        exclude = { "rust_analyzer" },
      },
    },
  },

  -- Completion
  {
    "saghen/blink.cmp",
    event = "InsertEnter",
    version = "1.*",
    dependencies = {
      "rafamadriz/friendly-snippets",
      { "Kaiser-Yang/blink-cmp-avante", version = false },
    },
    opts = {
      keymap = { preset = "default" },
      appearance = { nerd_font_variant = "mono" },
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "avante" },
        providers = {
          avante = {
            module = "blink-cmp-avante",
            name = "Avante",
            opts = {},
          },
        },
      },
      completion = { documentation = { auto_show = true } },
      signature = { enabled = true },
    },
  },
}
