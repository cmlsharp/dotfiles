return {
  "nvim-telescope/telescope.nvim",
  branch = "master",
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { "DrKJeff16/project.nvim", config = function() require("project").setup() end },
  },
}
