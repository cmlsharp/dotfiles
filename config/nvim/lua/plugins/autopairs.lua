return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = function()
    local npairs = require("nvim-autopairs")
    npairs.setup {}

    -- Disable single quote pairing for OCaml
    local rule = npairs.get_rule("'")
    if rule and rule[1] then
      rule[1].not_filetypes = { "ocaml" }
    end
  end,
}
