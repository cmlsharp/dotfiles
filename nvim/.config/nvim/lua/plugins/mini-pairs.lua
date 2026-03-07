return {
  "echasnovski/mini.pairs",
  event = "InsertEnter",
  opts = {
    mappings = {
      ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%a\\].", register = { cr = false } },
      ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\].", register = { cr = false } },
    },
  },
}
