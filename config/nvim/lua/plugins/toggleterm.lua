return {
  "akinsho/toggleterm.nvim",
  version = "*",
  opts = {
    size = function(term)
      if term.direction == "horizontal" then
        return math.floor(vim.o.lines * 0.3)
      elseif term.direction == "vertical" then
        return math.floor(vim.o.columns * 0.4)
      end
    end,
    open_mapping = [[<C-\>]],
    direction = "horizontal",
    shade_terminals = false,
    persist_size = false,
    on_open = function(term)
      if term.direction == "horizontal" then
        local target = math.floor(vim.o.lines * 0.3)
        vim.api.nvim_win_set_height(term.window, target)
      end
    end,
  },
}
