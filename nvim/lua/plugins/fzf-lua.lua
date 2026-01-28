return {
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-mini/mini.icons" },
		---@module "fzf-lua"
		---@type fzf-lua.Config|{}
		---@diagnostic disable: missing-fields
		opts = {
			winopts = {
				height = 0.9,
				width = 0.8,
			},
		},
		config = function(_, opts)
			require("fzf-lua").setup(opts)
			require("fzf-lua").register_ui_select()
		end,
		keys = {
			{
				"<leader>ff",
				function()
					require("fzf-lua").files()
				end,
				desc = "Find [F]iles",
			},
			{
				"<leader><leader>",
				function()
					require("fzf-lua").buffers()
				end,
				desc = "Find Buffers",
			},
			{
				"<leader>fg",
				function()
					require("fzf-lua").live_grep()
				end,
				desc = "Find [G]rep",
			},
			{
				"<leader>fr",
				function()
					require("fzf-lua").registers()
				end,
				desc = "Find [R]egisters",
			},
			{
				"<leader>fh",
				function()
					require("fzf-lua").help_tags()
				end,
				desc = "Find [H]elp",
			},
			{
				"<leader>fc",
				function()
					require("fzf-lua").colorschemes()
				end,
				desc = "Find [C]olorscheme",
			},
			{
				"gra",
				function()
					require("fzf-lua").lsp_code_actions()
				end,
				desc = "GoTo [A]ctions",
			},
			{
				"grd",
				function()
					require("fzf-lua").lsp_definitions()
				end,
				desc = "GoTo [D]efinitions",
			},
			{
				"grD",
				function()
					require("fzf-lua").lsp_declarations()
				end,
				desc = "GoTo [D]eclarations",
			},
			{
				"gri",
				function()
					require("fzf-lua").lsp_implementations()
				end,
				desc = "GoTo [I]mplementations",
			},
			{
				"grr",
				function()
					require("fzf-lua").lsp_references()
				end,
				desc = "GoTo [R]eferences",
			},
			{
				"grt",
				function()
					require("fzf-lua").lsp_typedefs()
				end,
				desc = "GoTo [T]ype Definitions",
			},
			{
				"grA",
				function()
					require("fzf-lua").diagnostics_document()
				end,
				desc = "GoTo Di[a]gnostics",
			},
		},
		---@diagnostic enable: missing-fields
	},
}
