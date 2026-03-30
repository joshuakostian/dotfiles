-- Settings
vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.o.swapfile = false
vim.o.clipboard = "unnamedplus"

vim.o.number = true
vim.o.signcolumn = "yes"

vim.opt.fillchars = { eob = " " }

vim.o.cursorline = true
vim.opt.showmode = false
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

-- Colorscheme
vim.pack.add({ "https://github.com/nendix/zen.nvim" })
require("zen").setup({
	transparent = true,
})
vim.cmd.colorscheme("zen")

-- Treesitter
vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" })
require("nvim-treesitter").install({ "rust", "lua", "cpp", "go" })
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "rust", "lua", "cpp", "go" },
	callback = function()
		vim.treesitter.start()
	end,
})

-- Lsp Config
vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mason-org/mason-lspconfig.nvim",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
})

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = { "lua_ls", "rust_analyzer", "clangd", "gopls" },
})
require("mason-tool-installer").setup({
	ensure_installed = { "stylua", "clang-format", "goimports" },
})
vim.lsp.config("lua_ls", {
	settings = { Lua = { diagnostics = { globals = { "vim" } } } },
})

-- Conform
vim.pack.add({ "https://github.com/stevearc/conform.nvim" })
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		rust = { "rustfmt" },
		cpp = { "clang-format" },
		go = { "goimports", "gofmt" },
	},
})
vim.keymap.set("n", "<leader>cf", function()
	local bufnr = vim.api.nvim_get_current_buf()
	require("conform").format({ bufnr = bufnr })
end, { desc = "Format current buffer with Conform" })

-- Blink Cmp
vim.pack.add({
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
	"https://github.com/rafamadriz/friendly-snippets",
})
require("blink.cmp").setup({
	keymap = { preset = "default" },
	appearance = {
		nerd_font_variant = "mono",
	},
	completion = { documentation = { auto_show = true } },
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},
	fuzzy = { implementation = "prefer_rust_with_warning" },
})

-- Yazi
vim.pack.add({
	{ src = "https://github.com/mikavilpas/yazi.nvim", version = vim.version.range("*") },
	"https://github.com/nvim-lua/plenary.nvim",
})
vim.keymap.set({ "n", "v" }, "<leader>-", function()
	require("yazi").yazi()
end, { desc = "Open yazi at the current file" })

-- fzf-lua
vim.pack.add({ "https://github.com/ibhagwan/fzf-lua" })

local fzf = require("fzf-lua")

-- Find files
vim.keymap.set("n", "<leader>ff", function()
	fzf.files()
end, { desc = "Find files" })

-- Live grep
vim.keymap.set("n", "<leader>fg", function()
	fzf.live_grep()
end, { desc = "Grep in files" })

-- Buffers list
vim.keymap.set("n", "<leader><leader>", function()
	fzf.buffers()
end, { desc = "List buffers" })

-- Indent Blankline
vim.pack.add({ "https://github.com/lukas-reineke/indent-blankline.nvim" })
require("ibl").setup()

-- Which Key
vim.pack.add({ "https://github.com/folke/which-key.nvim" })
require("which-key").setup({
	preset = "helix",
})

-- Inc Rename
vim.pack.add({ "https://github.com/smjonas/inc-rename.nvim" })
require("inc_rename").setup()
vim.keymap.set("n", "<leader>rn", ":IncRename ")

-- Mini Nvim
vim.pack.add({
	"https://github.com/nvim-mini/mini.icons",
	"https://github.com/nvim-mini/mini.statusline",
	"https://github.com/nvim-mini/mini.pairs",
})
require("mini.icons").setup()
require("mini.statusline").setup()
require("mini.pairs").setup()
