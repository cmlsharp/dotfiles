local function disable_for(npairs, char, filetypes)
  local rule = npairs.get_rule(char)
  if rule and rule[1] then
    rule[1].not_filetypes = filetypes
  end
end

return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = function()
    local npairs = require "nvim-autopairs"
    npairs.setup {}

    disable_for(npairs, "'", { "ocaml" })
    disable_for(npairs, "`", { "lean" })
  end,
}
