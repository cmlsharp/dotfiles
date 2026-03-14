return {
  "mfussenegger/nvim-dap",
  dependencies = {
    {
      "rcarriga/nvim-dap-ui",
      dependencies = { "nvim-neotest/nvim-nio" },
      opts = {},
      config = function(_, opts)
        local dapui = require("dapui")
        dapui.setup(opts)
        local dap = require("dap")
        dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
        dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
        dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
      end,
    },
    { "theHamsta/nvim-dap-virtual-text", opts = {} },
    {
      "jay-babu/mason-nvim-dap.nvim",
      opts = {
        ensure_installed = { "codelldb" },
        handlers = {},
      },
    },
  },
  keys = {
    { "<F5>", function() require("dap").continue() end, desc = "Continue / Start" },
    { "<S-F5>", function() require("dap").terminate() end, desc = "Terminate" },
    { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
    { "<S-F9>", function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end, desc = "Conditional breakpoint" },
    { "<F10>", function() require("dap").step_over() end, desc = "Step over" },
    { "<F11>", function() require("dap").step_into() end, desc = "Step into" },
    { "<S-F11>", function() require("dap").step_out() end, desc = "Step out" },
    { "<C-F5>", function() require("dap").run_to_cursor() end, desc = "Run to cursor" },
    { "<C-S-F5>", function() require("dap").run_last() end, desc = "Run last" },
    { "<F6>", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
    { "<S-F6>", function() require("dapui").toggle() end, desc = "Toggle DAP UI" },
    { "<F8>", function() require("dapui").eval() end, desc = "Eval expression", mode = { "n", "v" } },
    { "<F1>", function()
      local lines = {
        " DAP Cheatsheet ",
        "",
        " F5        Continue / Start",
        " Shift+F5  Terminate",
        " Ctrl+F5   Run to cursor",
        " C-S-F5    Run last",
        "",
        " F9        Toggle breakpoint",
        " Shift+F9  Conditional breakpoint",
        "",
        " F10       Step over",
        " F11       Step into",
        " Shift+F11 Step out",
        "",
        " F6        Toggle REPL",
        " Shift+F6  Toggle DAP UI",
        " F8        Eval expression",
        "",
        " Press any key to close",
      }
      local width = 32
      local buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
      local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = #lines,
        col = math.floor((vim.o.columns - width) / 2),
        row = math.floor((vim.o.lines - #lines) / 2),
        style = "minimal",
        border = "rounded",
      })
      vim.bo[buf].modifiable = false
      vim.keymap.set("n", "<Esc>", function()
        vim.api.nvim_win_close(win, true)
        vim.keymap.del("n", "<Esc>", { buffer = buf })
      end, { buffer = buf })
      vim.api.nvim_create_autocmd("BufLeave", {
        buffer = buf,
        once = true,
        callback = function() pcall(vim.api.nvim_win_close, win, true) end,
      })
      -- close on any keypress
      vim.defer_fn(function()
        local ok, key = pcall(vim.fn.getcharstr)
        if ok then
          pcall(vim.api.nvim_win_close, win, true)
          -- feed the key back if it's an action key
          if key ~= "\27" then vim.api.nvim_feedkeys(key, "m", false) end
        end
      end, 50)
    end, desc = "DAP cheatsheet" },
  },
}
