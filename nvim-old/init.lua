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

local map = vim.keymap.set

vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.o.swapfile = false
vim.o.clipboard = "unnamedplus"

vim.o.number = true
vim.o.signcolumn = "yes"

vim.opt.fillchars = { eob = " " }

vim.o.cursorline = true
vim.opt.showmode = true
vim.o.winborder = "single"

vim.o.tabstop = 4
vim.o.softtabstop = -1
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.shiftround = true
vim.o.wrap = false

vim.opt.sidescroll = 0
vim.opt.sidescrolloff = 0
vim.o.scrolloff = 5

vim.o.ignorecase = true
vim.o.smartcase = true

-- Keymaps.
map("n", "+", "$", { noremap = true })
map("n", "<C-s>", "<cmd>wall<CR>", { desc = "Save all buffers" })
map("n", "<leader>z", "<cmd>ZenMode<CR>", { desc = "Zen Mode" })

-- Setup lazy.nvim
require("lazy").setup({
	spec = {

		-- Colorscheme & appearance
		{
			"nendix/zen.nvim",
			lazy = false,
			priority = 1000,
			config = function()
				require("zen").setup({
					transparent = true,
				})
				-- vim.cmd.colorscheme("zen")
			end,
		},
		{
			"vague-theme/vague.nvim",
			lazy = false, -- make sure we load this during startup if it is your main colorscheme
			priority = 1000, -- make sure to load this before all the other plugins
			config = function()
				-- NOTE: you do not need to call setup if you don't want to.
				require("vague").setup({
					-- optional configuration here
					transparent = true,
				})
				vim.cmd("colorscheme vague")
			end,
		},
		{
			"brenoprata10/nvim-highlight-colors",
			opts = {
				render = "virtual",
				virtual_symbol = "■",
			},
		},

		-- Mason/Lspconfig
		{
			"mason-org/mason-lspconfig.nvim",
			opts = {
				ensure_installed = { "lua_ls", "rust_analyzer", "clangd", "gopls" },
			},
			dependencies = {
				{ "mason-org/mason.nvim", opts = {} },
				"neovim/nvim-lspconfig",
				opts = {
					vim.lsp.config("lua_ls", {
						settings = { Lua = { diagnostics = { globals = { "vim" } } } },
					}),
				},
				{
					"WhoIsSethDaniel/mason-tool-installer.nvim",
					opts = {
						ensure_installed = { "stylua", "clang-format", "goimports" },
					},
				},
			},
		},
		{
			"stevearc/conform.nvim",
			keys = {
				{
					"<leader>cf",
					function()
						require("conform").format({ async = true })
					end,
					mode = "",
					desc = "Format buffer",
				},
			},
			opts = {
				formatters_by_ft = {
					lua = { "stylua" },
					rust = { "rustfmt" },
					cpp = { "clang-format" },
					go = { "goimports", "gofmt" },
				},
			},
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
				signature = { enabled = true },
				sources = {
					default = { "lsp", "path", "snippets", "buffer" },
					per_filetype = {
						tex = { "lsp", "path", "snippets" },
					},
				},
				fuzzy = { implementation = "prefer_rust_with_warning" },
			},
			opts_extend = { "sources.default" },
		},
		{
			"nvim-flutter/flutter-tools.nvim",
			lazy = false,
			dependencies = {
				"nvim-lua/plenary.nvim",
			},
			config = true,
		},
		-- Latex
		{
			"lervag/vimtex",
			lazy = false, -- we don't want to lazy load VimTeX
			init = function()
				-- VimTeX configuration goes here, e.g.
				vim.g.vimtex_view_method = "skim"
			end,
		},

		-- Treesitter
		{
			"nvim-treesitter/nvim-treesitter",
			lazy = false,
			build = ":TSUpdate",
			config = function()
				require("nvim-treesitter").install({ "rust", "lua", "cpp", "go" })
				vim.api.nvim_create_autocmd("FileType", {
					pattern = { "rust", "lua", "cpp", "go" },
					callback = function()
						vim.treesitter.start()
					end,
				})
			end,
		},
		{
			"lukas-reineke/indent-blankline.nvim",
			main = "ibl",
			---@module "ibl"
			---@type ibl.config
			opts = {},
		},

		-- Files & navigation
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
		{
			"ibhagwan/fzf-lua",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			---@module "fzf-lua"
			---@type fzf-lua.Config|{}
			---@diagnostic disable: missing-fields
			config = function()
				require("fzf-lua").setup({
					winopts = {
						height = 0.95,
						width = 0.95,
						border = "single",
					},
				})
				require("fzf-lua").register_ui_select()

				map("n", "<leader>ff", "<cmd>FzfLua files<cr>", { desc = "Find Files" })
				map("n", "<leader><leader>", "<cmd>FzfLua buffers<cr>", { desc = "Open Buffers" })
				map("n", "<leader>fg", "<cmd>FzfLua live_grep<cr>", { desc = "Grep Project" })
				map("n", "<leader>fs", "<cmd>FzfLua lsp_document_symbols<cr>", { desc = "Document Symbols" })
				map("n", "<leader>fd", "<cmd>FzfLua lsp_document_diagnostics<cr>", { desc = "Document Diagnostics" })
				map("n", "<leader>fq", "<cmd>FzfLua quickfix<cr>", { desc = "Quickfix List" })
			end,
			---@diagnostic enable: missing-fields
		},
		{
			"smjonas/inc-rename.nvim",
			config = function()
				require("inc_rename").setup()
				vim.keymap.set("n", "<leader>rn", ":IncRename ", { desc = "Inc Rename" })
			end,
		},
		{
			"folke/which-key.nvim",
			event = "VeryLazy",
			opts = {
				preset = "helix",
			},
			keys = {
				{
					"<leader>?",
					function()
						require("which-key").show({ global = false })
					end,
					desc = "Buffer Local Keymaps (which-key)",
				},
			},
		},
		{
			"windwp/nvim-autopairs",
			event = "InsertEnter",
			config = true,
			opts = {},
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
				easing = "sine",
			},
		},
		{
			"folke/zen-mode.nvim",
			opts = {
				width = 100,
			},
		},
		{
			"j-hui/fidget.nvim",
			opts = {},
		},
		{
			"rachartier/tiny-inline-diagnostic.nvim",
			event = "VeryLazy",
			priority = 1000,
			config = function()
				require("tiny-inline-diagnostic").setup({
					preset = "ghost",
					transparent_bg = true,
				})
				vim.diagnostic.config({ virtual_text = false }) -- Disable Neovim's default virtual text diagnostics
			end,
		},
		{
			"lewis6991/gitsigns.nvim",
			opts = {},
		},
		{
			"christoomey/vim-tmux-navigator",
			cmd = {
				"TmuxNavigateLeft",
				"TmuxNavigateDown",
				"TmuxNavigateUp",
				"TmuxNavigateRight",
				"TmuxNavigatePrevious",
				"TmuxNavigatorProcessList",
			},
			keys = {
				{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
				{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
				{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
				{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
				{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
			},
		},
	},

	install = { colorscheme = { "koda" } },
	checker = { enabled = false },
	ui = { border = "single" },
})
