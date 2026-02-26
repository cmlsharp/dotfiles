return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  config = function()
    local dashboard = require("alpha.themes.dashboard")

    -- Build last session label from path
    local last_label = "Last session"
    local ok, utils = pcall(require, "session_manager.utils")
    if ok then
      local last = utils.get_last_session_filename()
      if last then
        local sm_config = require("session_manager.config")
        local dir = tostring(sm_config.session_filename_to_dir(last))
        local short = dir:gsub("^" .. vim.pesc(vim.fn.expand("~")), "~")
        if #short <= 30 then
          last_label = "Last session (" .. short .. ")"
        else
          local parts = vim.split(dir, "/", { trimempty = true })
          local n = #parts
          if n >= 2 then
            last_label = "Last session (../" .. parts[n - 1] .. "/" .. parts[n] .. ")"
          elseif n >= 1 then
            last_label = "Last session (../" .. parts[n] .. ")"
          end
        end
      end
    end

    dashboard.section.buttons.val = {
      dashboard.button("s", "  " .. last_label, ":SessionManager load_last_session<CR>"),
      dashboard.button("S", "  Sessions", ":SessionManager load_session<CR>"),
      dashboard.button("o", "  Open project", ":lua require('alpha.projects').open()<CR>"),
      dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
      dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
      dashboard.button("q", "  Quit", ":qa<CR>"),
    }
    require("alpha").setup(dashboard.config)
  end,
}
