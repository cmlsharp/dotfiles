return {
	"stevearc/oil.nvim",
	lazy = false,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	keys = {
		{ "<C-b>", "<cmd>Oil --float<CR>", desc = "Open file browser" },
	},
	opts = {
		default_file_explorer = true,
		keymaps = {
			["<C-b>"] = { "actions.close", mode = "n" },
		},
	},
}
