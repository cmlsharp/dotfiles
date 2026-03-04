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
    { "cljoly/telescope-repo.nvim" },
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
      defaults = require("telescope.themes").get_ivy(),
      extensions = {
        ["ui-select"] = { require("telescope.themes").get_dropdown() },
      },
    }

    pcall(telescope.load_extension, "fzf")
    pcall(telescope.load_extension, "ui-select")
    pcall(telescope.load_extension, "project")
    pcall(telescope.load_extension, "repo")

    local builtin = require "telescope.builtin"
    vim.keymap.set("n", "<C-p>", builtin.git_files, { desc = "Telescope git files" })
    vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
    vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
    vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
    vim.keymap.set("n", "<leader>sS", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
    vim.keymap.set({ "n", "v" }, "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
    vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
    vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
    vim.keymap.set("n", "<leader>sc", builtin.commands, { desc = "[S]earch [C]ommands" })
    vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
    vim.keymap.set("n", "<leader>ss", "<cmd>SessionManager load_session<CR>", { desc = "[S]earch [s]essions" })
    vim.keymap.set("n", '<leader>s"', builtin.registers, { desc = "[S]earch registers" })
    vim.keymap.set("n", "<leader>s.", builtin.resume, { desc = "Resume search" })
    vim.keymap.set("n", "<leader>sp", telescope.extensions.projects.projects, { desc = "[S]earch [P]rojects" })
    vim.keymap.set("n", "<leader>sgc", builtin.git_commits, { desc = "[S]earch [G]it [C]ommits" })
    vim.keymap.set("n", "<leader>sgB", builtin.git_bcommits, { desc = "[S]earch [G]it [B]uffer commits" })
    vim.keymap.set("n", "<leader>sgb", builtin.git_branches, { desc = "[S]earch [G]it [B]ranches" })

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("telescope-lsp-attach", { clear = true }),
      callback = function(event)
        local buf = event.buf

        vim.keymap.set("n", "grr", builtin.lsp_references, { buffer = buf, desc = "[G]oto [R]eferences" })
        vim.keymap.set("n", "gri", builtin.lsp_implementations, { buffer = buf, desc = "[G]oto [I]mplementation" })
        vim.keymap.set("n", "grd", builtin.lsp_definitions, { buffer = buf, desc = "[G]oto [D]efinition" })
        vim.keymap.set("n", "gd", builtin.lsp_definitions, { buffer = buf, desc = "[G]oto [D]efinition" })
        vim.keymap.set("n", "gO", builtin.lsp_document_symbols, { buffer = buf, desc = "Open Document Symbols" })
        vim.keymap.set(
          "n",
          "gW",
          builtin.lsp_dynamic_workspace_symbols,
          { buffer = buf, desc = "Open Workspace Symbols" }
        )
        vim.keymap.set("n", "grt", builtin.lsp_type_definitions, { buffer = buf, desc = "[G]oto [T]ype Definition" })
      end,
    })

    vim.keymap.set("n", "<leader>/", function()
      builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = "[/] Fuzzily search in current buffer" })

    vim.keymap.set("n", "<leader>s/", function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = "Live Grep in Open Files",
      }
    end, { desc = "[S]earch [/] in Open Files" })

    vim.keymap.set("n", "<leader>sn", function()
      builtin.find_files { cwd = vim.fn.stdpath "config" }
    end, { desc = "[S]earch [N]eovim files" })
  end,
}
