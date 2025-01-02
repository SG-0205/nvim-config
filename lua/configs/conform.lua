local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    html = { "prettier" },
    -- cpp = { "clang-format -style=Google" },
    c = { "c_formatter_42" },
  },
  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function(args)
      require("conform").format { bufnr = args.buf }
    end,
  }),
  format_on_save = {
    -- These options will be passed to conform.format()
    -- timeout_ms = 500,
    -- lsp_fallback = true,
    false,
  },
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true }),
    pattern = { "*.c", "*.cpp", "*.h", "*.hpp" },
    callback = function()
      local clang_format = "clang-format"
      local bufnr = vim.api.nvim_get_current_buf()
      local file_content = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      local formatted_content = vim.fn.systemlist(clang_format .. " --style=Google", file_content)
      if vim.v.shell_error == 0 then
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, formatted_content)
      end
    end,
  }),
}

return options
