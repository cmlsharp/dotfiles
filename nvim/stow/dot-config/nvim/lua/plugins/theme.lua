-- Theme management (managed by theme-set)
-- Reads ~/.config/theme/current/nvim-theme.txt to determine active colorscheme

local function get_theme()
  local f = io.open(vim.fn.expand "~/.config/theme/current/nvim-theme.txt", "r")
  if f then
    local theme = f:read "*l"
    f:close()
    if theme and theme ~= "" then
      return vim.trim(theme)
    end
  end
  return "catppuccin"
end

local theme = get_theme()

-- Map of colorscheme -> plugin spec
local theme_plugins = {
  ["catppuccin"] = { "catppuccin/nvim", name = "catppuccin" },
  ["catppuccin-latte"] = { "catppuccin/nvim", name = "catppuccin" },
  ["tokyonight"] = { "folke/tokyonight.nvim" },
  ["gruvbox-material"] = { "sainnhe/gruvbox-material" },
  ["nord"] = { "shaunsingh/nord.nvim" },
  ["everforest"] = { "sainnhe/everforest" },
  ["kanagawa"] = { "rebelot/kanagawa.nvim" },
  ["rose-pine"] = { "rose-pine/neovim", name = "rose-pine" },
  ["miasma"] = { "xero/miasma.nvim" },
}

local spec = theme_plugins[theme] or theme_plugins["catppuccin"]

return {
  spec[1],
  name = spec.name or nil,
  priority = 1000,
  lazy = false,
  config = function()
    -- Theme-specific setup
    if theme == "catppuccin" or theme == "catppuccin-latte" then
      require("catppuccin").setup {}
    end
    vim.cmd.colorscheme(theme)

    vim.api.nvim_set_hl(0, "Normal", { bg = "None" })
    vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
    vim.api.nvim_set_hl(0, "TreesitterContext", { link = "Normal" })
    vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { link = "Normal" })
    vim.api.nvim_set_hl(0, "SnacksIndentScope", { fg = "#dddddd" })
  end,
}
