return {
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy",
		priority = 1000,
		config = function()
			require("tiny-inline-diagnostic").setup({
				preset = "ghost",
				transparent_bg = true,
				options = {
					multilines = {
						enabled = true,
						always_show = true,
					},
					show_code = false,
				},
			})
			vim.diagnostic.config({ virtual_text = false })
		end,
	},
}
