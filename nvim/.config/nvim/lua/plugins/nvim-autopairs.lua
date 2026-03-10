return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = function(plugin)
    plugin.get_rule("'")[1].not_filetypes = { "ocaml" }
    plugin.get_rule("`")[1].not_filetypes = { "lean" }
  end,
}
