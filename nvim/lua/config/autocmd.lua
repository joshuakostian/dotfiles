vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.tex",
  callback = function()
    vim.fn.jobstart({"latexmk", "-pdf", vim.fn.expand("%")})
  end,
})
