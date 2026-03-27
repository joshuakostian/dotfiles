-- Settings
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

vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})

-- Vim Pack
local gh = function(x) return 'https://github.com/' .. x end
vim.pack.add({
    gh('vague-theme/vague.nvim'),
    gh('slugbyte/lackluster.nvim'),
    gh('nvim-treesitter/nvim-treesitter'),
    {
        src = gh('saghen/blink.cmp'),
        version = vim.version.range('1.*')
    },
    gh('neovim/nvim-lspconfig'),
    gh('mason-org/mason.nvim'),
    gh('mason-org/mason-lspconfig.nvim'),
})

-- Colorscheme
require("vague").setup({
    transparent = true
})
require("lackluster").setup({
    tweak_background = { normal = 'none' },
})
vim.cmd("colorscheme lackluster-mint")

-- Treesitter
require("nvim-treesitter").install({ "rust", "lua", "cpp", "go" })
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "rust", "lua", "cpp", "go" },
    callback = function()
        vim.treesitter.start()
    end,
})

vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name == 'nvim-treesitter' and kind == 'update' then
            if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
            vim.cmd('TSUpdate')
        end
    end
})

-- Blink Cmp
require('blink.cmp').setup({
    keymap = { preset = 'default' },
    appearance = { nerd_font_variant = 'mono' },
    completion = {
        documentation = { auto_show = true },
    },
    sources = {
        default = { 'lsp', 'path', 'buffer' },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
})

-- Lsp Config
require("mason").setup()
require("mason-lspconfig").setup {
    ensure_installed = { "lua_ls", "rust_analyzer", "gopls" },
}
