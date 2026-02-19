-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Settings
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.o.swapfile = false
vim.o.clipboard = "unnamedplus"

vim.o.number = true
vim.o.signcolumn = "yes"
vim.opt.fillchars = { eob = " " }

vim.o.cursorline = true
vim.opt.showmode = false
vim.o.winborder = "bold"

vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.smarttab = true
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.shiftround = true
vim.o.wrap = false

vim.opt.sidescroll = 0
vim.opt.sidescrolloff = 0
vim.o.scrolloff = 5

vim.o.ignorecase = true
vim.o.smartcase = true

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- Colorscheme and appearance
		{
			"nendix/zen.nvim",
			lazy = false,
			priority = 1000,
			config = function()
				vim.cmd.colorscheme("zen")
			end,
		},
		{
			"nvim-lualine/lualine.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			opts = {},
		},
		{
			"lukas-reineke/indent-blankline.nvim",
			main = "ibl",
			---@module "ibl"
			---@type ibl.config
			opts = {},
		},
		-- LSP, formatter, code complete and diagnostics
		{
			"mason-org/mason-lspconfig.nvim",
			opts = {
				ensure_installed = { "lua_ls", "rust_analyzer" },
			},
			dependencies = {
				{ "mason-org/mason.nvim", opts = {} },
				"neovim/nvim-lspconfig",
				{
					"WhoIsSethDaniel/mason-tool-installer.nvim",
					opts = {
						ensure_installed = { "stylua" },
					},
				},
			},
		},
		{
			"stevearc/conform.nvim",
			config = function()
				require("conform").setup({
					formatters_by_ft = {
						lua = { "stylua" },
						rust = { "rustfmt" },
					},
				})
				vim.keymap.set("n", "<leader>cf", function()
					require("conform").format({ async = true, lsp_fallback = true })
				end, { desc = "Format buffer" })
			end,
		},
		{
			"saghen/blink.cmp",
			dependencies = { "rafamadriz/friendly-snippets" },
			version = "1.*",
			---@module 'blink.cmp'
			---@type blink.cmp.Config
			opts = {
				keymap = { preset = "default" },
				appearance = {
					nerd_font_variant = "mono",
				},
				completion = { documentation = { auto_show = true } },
				sources = {
					default = { "lsp", "path", "snippets", "buffer" },
				},
				fuzzy = { implementation = "prefer_rust_with_warning" },
			},
			opts_extend = { "sources.default" },
		},
		{
			"rachartier/tiny-inline-diagnostic.nvim",
			event = "VeryLazy",
			priority = 1000,
			config = function()
				require("tiny-inline-diagnostic").setup({
					preset = "simple",
					transparent_bg = true,
					show_code = false,
					options = {
						add_messages = {
							display_count = true,
						},
						multilines = {
							enabled = true,
						},
					},
				})
				vim.diagnostic.config({ virtual_text = false }) -- Disable Neovim's default virtual text diagnostics
			end,
		},
		-- Treesitter and code navigation
		{
			"nvim-treesitter/nvim-treesitter",
			lazy = false,
			build = ":TSUpdate",
			config = function()
				require("nvim-treesitter").install({ "rust", "lua" })
				vim.api.nvim_create_autocmd("FileType", {
					pattern = { "rust", "lua" },
					callback = function()
						vim.treesitter.start()
					end,
				})
			end,
		},
		{
			"folke/flash.nvim",
			event = "VeryLazy",
			---@type Flash.Config
			opts = {},
			keys = {
				{
					"s",
					mode = { "n", "x", "o" },
					function()
						require("flash").jump()
					end,
					desc = "Flash",
				},
			},
		},
		{
			"karb94/neoscroll.nvim",
			opts = {
        easing = 'sine',
      },
		},
		-- Code manipulation
		{
			"smjonas/inc-rename.nvim",
			config = function()
				require("inc_rename").setup()
				vim.keymap.set("n", "<leader>rn", ":IncRename ", { desc = "Inc Rename" })
			end,
		},
		-- FZF
		{
			"ibhagwan/fzf-lua",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			-- dependencies = { "nvim-mini/mini.icons" },
			---@module "fzf-lua"
			---@type fzf-lua.Config|{}
			---@diagnostic disable: missing-fields
			config = function()
				require("fzf-lua").setup({
					winopts = {
						height = 0.95,
						width = 0.95,
					},
				})
				vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua files<cr>", { desc = "Find Files" })
				vim.keymap.set("n", "<leader><leader>", "<cmd>FzfLua buffers<cr>", { desc = "Open Buffers" })
				vim.keymap.set("n", "<leader>fg", "<cmd>FzfLua live_grep_native<cr>", { desc = "Grep Project" })
			end,
			---@diagnostic enable: missing-fields
		},
		-- Yazi
		---@type LazySpec
		{
			"mikavilpas/yazi.nvim",
			version = "*", -- use the latest stable version
			event = "VeryLazy",
			dependencies = {
				{ "nvim-lua/plenary.nvim", lazy = true },
			},
			keys = {
				{
					"<leader>-",
					mode = { "n", "v" },
					"<cmd>Yazi<cr>",
					desc = "Open yazi at the current file",
				},
			},
			---@type YaziConfig | {}
			opts = {
				open_for_directories = true,
				keymaps = {
					show_help = "<f1>",
				},
			},
			-- if you use `open_for_directories=true`, this is recommended
			init = function()
				vim.g.loaded_netrwPlugin = 1
			end,
		},
	},

	-- Lazy opts
	install = { colorscheme = { "zen" } },
	checker = { enabled = false },
	ui = { border = "bold" },
})
