local null_ls = require "null-ls"

-- Configure clang-format avec le style Google
null_ls.setup {
  sources = {
    null_ls.builtins.formatting.clang_format.with {
      extra_args = { "--style=Google" }, -- Appliquer le style Google
    },
  },
  on_attach = function(client, bufnr)
    -- Activer le formatage automatique lors de la sauvegarde
    if client.supports_method "textDocument/formatting" then
      vim.api.nvim_clear_autocmds { group = 0, buffer = bufnr }
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true }),
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format { async = false } -- Formate le fichier avant sauvegarde
        end,
      })
    end
  end,
}
