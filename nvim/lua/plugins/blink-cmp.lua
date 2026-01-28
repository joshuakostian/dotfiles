return {
	{
		"saghen/blink.cmp",
		version = "1.*",
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
      enabled = function() return not vim.tbl_contains({ "typr" }, vim.bo.filetype) end,
			keymap = { preset = "default" },
			appearance = {
				highlight_ns = vim.api.nvim_create_namespace("blink_cmp"),
				nerd_font_variant = "mono",
			},
			completion = {
				menu = {
					draw = {
						columns = {
							{ "label", "label_description", gap = 1 },
							{ "kind_icon", "kind", gap = 1 },
						},
					},
					border = "single",
				},
				documentation = { auto_show = true, auto_show_delay_ms = 500 },
				-- ghost_text = { enabled = true },
			},
			signature = {
        enabled = true;
        window = { border = "single" }
      },
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
	},
}
