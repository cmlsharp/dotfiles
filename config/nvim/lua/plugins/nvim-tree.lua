return {
  "nvim-tree/nvim-tree.lua",
  cmd = { "NvimTreeToggle", "NvimTreeFocus" },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  init = function()
    -- Auto-open nvim-tree when opening a directory
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function(data)
        if vim.fn.isdirectory(data.file) == 1 then
          vim.cmd.cd(data.file)
          require("nvim-tree.api").tree.open()
        end
      end,
    })
  end,
  opts = {},
}
