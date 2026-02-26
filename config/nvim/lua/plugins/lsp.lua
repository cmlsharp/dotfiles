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
          map("n", "<leader>ra", vim.lsp.buf.rename, opts)
          map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
          map("n", "<C-k>", vim.lsp.buf.signature_help, opts)
          map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
          map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
          map("n", "[d", vim.diagnostic.goto_prev, opts)
          map("n", "]d", vim.diagnostic.goto_next, opts)
        end,
      })

      vim.lsp.config("*", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
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
      ensure_installed = { "html", "cssls", "clangd" },
      automatic_enable = {
        exclude = { "rust_analyzer" },
      },
    },
  },

  -- Completion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lua",
      { "https://codeberg.org/FelipeLema/cmp-async-path.git", name = "cmp-async-path" },
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
      {
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
    },
    config = function()
      local cmp = require "cmp"
      local luasnip = require "luasnip"

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm { select = true },
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "nvim_lua" },
          { name = "async_path" },
        }, {
          { name = "buffer" },
        }),
      }

      -- Avante completion sources for the chat input
      cmp.setup.filetype("AvanteInput", {
        sources = cmp.config.sources({
          { name = "avante_commands" },
          { name = "avante_mentions" },
          { name = "avante_files" },
        }),
      })
    end,
  },
}
