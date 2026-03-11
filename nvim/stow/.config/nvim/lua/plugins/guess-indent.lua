return {
  "nmac427/guess-indent.nvim",
  event = "BufReadPre",
  config = function()
    require("guess-indent").setup {}
  end,
}
