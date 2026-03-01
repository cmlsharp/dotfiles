return {
  "nvim-telescope/telescope.nvim",
  enabled = true,
  event = "VimEnter",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable "make" == 1
      end,
    },
    { "nvim-telescope/telescope-ui-select.nvim" },
    { "nvim-tree/nvim-web-devicons" },
    {
      "DrKJeff16/project.nvim",
      config = function()
        require("project").setup()
      end,
    },
  },
  config = function()
    local telescope = require "telescope"
    telescope.setup {
      -- You can put your default mappings / updates / etc. in here
      --  All the info you're looking for is in `:help telescope.setup()`
      --
      -- defaults = {
      --   mappings = {
      --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
      --   },
      -- },
      -- pickers = {}
      extensions = {
        ["ui-select"] = { require("telescope.themes").get_dropdown() },
      },
    }

    pcall(telescope.load_extension, "fzf")
    pcall(telescope.load_extension, "ui-select")
    pcall(telescope.load_extension, "project")

    local builtin = require "telescope.builtin"
    vim.keymap.set("n", "<C-p>", builtin.git_files, { desc = "Telescope git files" })
    vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
    vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
    vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
    vim.keymap.set("n", "<leader>sS", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
    vim.keymap.set({ "n", "v" }, "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
    vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
    vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
    vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
    vim.keymap.set("n", "<leader>sc", builtin.commands, { desc = "[S]earch [C]ommands" })
    vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
    vim.keymap.set("n", "<leader>ss", "<cmd>SessionManager load_session<CR>", { desc = "[S]earch [s]essions" })
    vim.keymap.set("n", '<leader>s"', builtin.registers, { desc = "[S]earch registers" })
    vim.keymap.set("n", "<leader>s.", builtin.resume, { desc = "Resume search" })
    vim.keymap.set("n", "<leader>sp", telescope.extensions.projects.projects, { desc = "[S]earch [P]rojects" })
    vim.keymap.set("n", "<leader>sgc", builtin.git_commits, { desc = "[S]earch [G]it [C]ommits" })
    vim.keymap.set("n", "<leader>sgB", builtin.git_bcommits, { desc = "[S]earch [G]it [B]uffer commits" })
    vim.keymap.set("n", "<leader>sgb", builtin.git_branches, { desc = "[S]earch [G]it [B]ranches" })

    -- This runs on LSP attach per buffer (see main LSP attach function in 'neovim/nvim-lspconfig' config for more info,
    -- it is better explained there). This allows easily switching between pickers if you prefer using something else!
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("telescope-lsp-attach", { clear = true }),
      callback = function(event)
        local buf = event.buf

        -- Find references for the word under your cursor.
        vim.keymap.set("n", "grr", builtin.lsp_references, { buffer = buf, desc = "[G]oto [R]eferences" })

        -- Jump to the implementation of the word under your cursor.
        -- Useful when your language has ways of declaring types without an actual implementation.
        vim.keymap.set("n", "gri", builtin.lsp_implementations, { buffer = buf, desc = "[G]oto [I]mplementation" })

        -- Jump to the definition of the word under your cursor.
        -- This is where a variable was first declared, or where a function is defined, etc.
        -- To jump back, press <C-t>.
        vim.keymap.set("n", "grd", builtin.lsp_definitions, { buffer = buf, desc = "[G]oto [D]efinition" })

        -- Fuzzy find all the symbols in your current document.
        -- Symbols are things like variables, functions, types, etc.
        vim.keymap.set("n", "gO", builtin.lsp_document_symbols, { buffer = buf, desc = "Open Document Symbols" })

        -- Fuzzy find all the symbols in your current workspace.
        -- Similar to document symbols, except searches over your entire project.
        vim.keymap.set(
          "n",
          "gW",
          builtin.lsp_dynamic_workspace_symbols,
          { buffer = buf, desc = "Open Workspace Symbols" }
        )

        -- Jump to the type of the word under your cursor.
        -- Useful when you're not sure what type a variable is and you want to see
        -- the definition of its *type*, not where it was *defined*.
        vim.keymap.set("n", "grt", builtin.lsp_type_definitions, { buffer = buf, desc = "[G]oto [T]ype Definition" })
      end,
    })

    -- Override default behavior and theme when searching
    vim.keymap.set("n", "<leader>/", function()
      -- You can pass additional configuration to Telescope to change the theme, layout, etc.
      builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = "[/] Fuzzily search in current buffer" })

    -- It's also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    vim.keymap.set("n", "<leader>s/", function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = "Live Grep in Open Files",
      }
    end, { desc = "[S]earch [/] in Open Files" })

    -- Shortcut for searching your Neovim configuration files
    vim.keymap.set("n", "<leader>sn", function()
      builtin.find_files { cwd = vim.fn.stdpath "config" }
    end, { desc = "[S]earch [N]eovim files" })
  end,
}
