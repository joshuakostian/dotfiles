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
vim.opt.showmode = true
vim.o.winborder = "bold"

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

-- Misc.
vim.keymap.set("n", "+", "$", { noremap = true })
vim.keymap.set("n", "<C-s>", "<cmd>wall<CR>", { desc = "Save all buffers" })

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
				vim.cmd.colorscheme("zen")
			end,
		},
		{
			"lukas-reineke/indent-blankline.nvim",
			main = "ibl",
			---@module "ibl"
			---@type ibl.config
			opts = {},
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
				ensure_installed = { "lua_ls", "rust_analyzer", "clangd" },
			},
			dependencies = {
				{ "mason-org/mason.nvim", opts = {} },
				"neovim/nvim-lspconfig",
				{
					"WhoIsSethDaniel/mason-tool-installer.nvim",
					opts = {
						ensure_installed = { "stylua", "clang-format" },
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
				},
				fuzzy = { implementation = "prefer_rust_with_warning" },
			},
			opts_extend = { "sources.default" },
		},
		{
			"j-hui/fidget.nvim",
			opts = {},
		},

		-- Treesitter
		{
			"nvim-treesitter/nvim-treesitter",
			lazy = false,
			build = ":TSUpdate",
			config = function()
				require("nvim-treesitter").install({ "rust", "lua", "cpp" })
				vim.api.nvim_create_autocmd("FileType", {
					pattern = { "rust", "lua", "cpp" },
					callback = function()
						vim.treesitter.start()
					end,
				})
			end,
		},

		-- Files & navigation
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
					},
				})
				local map = vim.keymap.set
				map("n", "<leader>ff", "<cmd>FzfLua files<cr>", { desc = "Find Files" })
				map("n", "<leader><leader>", "<cmd>FzfLua buffers<cr>", { desc = "Open Buffers" })
				map("n", "<leader>fg", "<cmd>FzfLua live_grep<cr>", { desc = "Grep Project" })
				map("n", "<leader>fs", "<cmd>FzfLua lsp_document_symbols<cr>", { desc = "Document Symbols" })
				map("n", "<leader>fd", "<cmd>FzfLua lsp_document_diagnostics<cr>", { desc = "Document Diagnostics" })
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
			"rachartier/tiny-inline-diagnostic.nvim",
			event = "VeryLazy",
			priority = 1000,
			config = function()
				require("tiny-inline-diagnostic").setup({
					preset = "simple",
				})
				vim.diagnostic.config({ virtual_text = false }) -- Disable Neovim's default virtual text diagnostics
			end,
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
	ui = { border = "bold" },
})
