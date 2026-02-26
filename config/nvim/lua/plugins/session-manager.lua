return {
  "Shatur/neovim-session-manager",
  dependencies = { "nvim-lua/plenary.nvim" },
  lazy = false,
  config = function()
    local config = require("session_manager.config")
    require("session_manager").setup({
      autoload_mode = config.AutoloadMode.Disabled,
      autosave_only_in_session = true,
      autosave_ignore_filetypes = { "alpha" },
    })
  end,
}
