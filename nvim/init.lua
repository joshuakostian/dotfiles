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

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.o.swapfile = false
vim.o.clipboard = "unnamedplus"

vim.o.number = true
vim.o.signcolumn = "yes"
vim.o.colorcolumn = "80"

vim.opt.fillchars = { eob = " " }
vim.opt.guicursor = ""

vim.o.cursorline = true
vim.opt.showmode = false
vim.o.winborder = "single"

vim.o.tabstop = 2
vim.o.softtabstop = -1
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.shiftround = true
vim.o.wrap = false

vim.opt.sidescroll = 0
vim.opt.sidescrolloff = 0
vim.o.scrolloff = 10

vim.o.ignorecase = true
vim.o.smartcase = true

vim.keymap.set("n", "<leader>cf", function()
	require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format buffer" })

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- Colorscheme
		{
			"nendix/zen.nvim",
			lazy = false,
			priority = 1000,
			opts = {
				transparent = true,
			},
			config = function(_, opts)
				require("zen").setup(opts)
				vim.cmd.colorscheme("zen")
			end,
		},

		-- LSP Config
		{
			"mason-org/mason-lspconfig.nvim",
			opts = {
				ensure_installed = { "lua_ls", "gopls" },
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

		-- Conform
		{
			"stevearc/conform.nvim",
			opts = {
				lua = { "stylua" },
			},
		},

		-- Blink Cmp
		{
			"saghen/blink.cmp",
			version = "1.*",
			---@module 'blink.cmp'
			---@type blink.cmp.Config
			opts = {
				keymap = { preset = "default" },
				appearance = {
					nerd_font_variant = "mono",
				},
				completion = {
					documentation = { auto_show = true },
					ghost_text = {
						enabled = true,
					},
				},
				sources = {
					default = { "lsp", "path", "buffer" },
					per_filetype = {
						markdown = { "lsp" },
						latex = { "lsp" },
					},
				},
				fuzzy = { implementation = "prefer_rust_with_warning" },
				signature = {
					enabled = true,
					trigger = {
						enabled = true,
					},
				},
			},
			opts_extend = { "sources.default" },
		},

		-- FZF
		{
			"ibhagwan/fzf-lua",
			dependencies = { "nvim-mini/mini.icons" },
			---@module "fzf-lua"
			---@type fzf-lua.Config|{}
			---@diagnostic disable: missing-fields
			opts = {},
			keys = {
				{
					"<leader>ff",
					function()
						require("fzf-lua").files()
					end,
					desc = "Find files",
				},
				{
					"<leader>fg",
					function()
						require("fzf-lua").live_grep()
					end,
					desc = "Grep in files",
				},
				{
					"<leader><leader>",
					function()
						require("fzf-lua").buffers()
					end,
					desc = "List buffers",
				},
			},
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
			init = function()
				vim.g.loaded_netrwPlugin = 1
			end,
		},

		-- Inline diagnostic
		{
			"rachartier/tiny-inline-diagnostic.nvim",
			event = "VeryLazy",
			priority = 1000,
			opts = {
				preset = "ghost",
				transparent_bg = true,
				multilines = {
					enabled = true,
				},
			},
			config = function(_, opts)
				require("tiny-inline-diagnostic").setup(opts)
				vim.diagnostic.config({ virtual_text = false }) -- Disable Neovim's default virtual text diagnostics
			end,
		},
	},
	install = { colorscheme = { "zen" } },
	checker = { enabled = true },
})
