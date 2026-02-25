require("nvchad.configs.lspconfig").defaults()

local servers = {
  "html",
  "cssls",
  "clangd",
  "bashls",
  "css-lsp",
  "docker-compose-language-service",
  "dockerfile-language-server",
  "html-lsp",
  "intelephense",
  "lua-language-server",
  "luau-lsp",
  "marksman",
  "nginx-language-server",
  "pylsp",
  "stylua",
  "ts_ls",
  "tailwindcss"}
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers 
