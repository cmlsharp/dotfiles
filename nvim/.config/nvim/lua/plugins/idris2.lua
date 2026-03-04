return {
  "idris-community/idris2-nvim",
  event = { "BufReadPre *.idr", "BufNewFile *.idr" },
  dependencies = { "MunifTanjim/nui.nvim" },
  opts = function()
    local capabilities = require("blink.cmp").get_lsp_capabilities()

    return {
      client = {
        hover = {
          use_split = false,
          split_size = "20%",
          auto_resize_split = true,
          split_position = "bottom",
          with_history = false,
          use_as_popup = false,
        },
      },
      server = {
        capabilities = capabilities,
      },
      autostart_semantic = false,
      code_action_post_hook = function(action) end,
      use_default_semantic_hl_groups = false,
      default_regexp_syntax = true,
    }
  end,
}
