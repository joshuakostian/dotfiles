vim.keymap.set("n", "<leader>dt", "<cmd>TinyInlineDiag toggle<cr>", { desc = "Toggle diagnostics" })

vim.keymap.set("n", "<C-s>", "<cmd>wa<cr>", { desc = "Write All" })

vim.keymap.set("n", "<leader>cf", function()
	vim.lsp.buf.format()
end, { desc = "Code Format" })

vim.keymap.set("n", "<leader>a", "<cmd>LspClangdSwitchSourceHeader<cr>", { desc = "Switch Header/Source" })

vim.keymap.set("n", "<leader>z", "<cmd>ZenMode<cr>", { desc = "ZenMode" })

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

