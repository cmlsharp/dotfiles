return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = function()
    local plugin = require "nvim-autopairs"
    plugin.setup {}
    plugin.get_rule("'")[1].not_filetypes = { "ocaml" }
  end,
}
