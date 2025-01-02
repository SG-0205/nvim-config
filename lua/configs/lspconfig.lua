-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

-- EXAMPLE
local servers = { "html", "cssls", "clangd", "bashls", "cmake", "intelephense" }
local nvlsp = require "nvchad.configs.lspconfig"

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
    diagnostics = {
      update_on_insert = true,
    },
  }
end

lspconfig.bashls.setup {
  default_config = {
    diagnostics = {
      update_on_insert = true,
    },
    cmd = { "bash-language-server", "start" },
    settings = {
      bashIde = {
        -- Glob pattern for finding and parsing shell script files in the workspace.
        -- Used by the background analysis features across files.

        -- Prevent recursive scanning which will cause issues when opening a file
        -- directly in the home directory (e.g. ~/foo.sh).
        --
        -- Default upstream pattern is "**/*@(.sh|.inc|.bash|.command)".
        globPattern = vim.env.GLOB_PATTERN or "*@(.sh|.inc|.bash|.command)",
      },
    },
    filetypes = { "bash", "sh", "zsh" },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find(".git", { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/bash-lsp/bash-language-server

`bash-language-server` can be installed via `npm`:
```sh
npm i -g bash-language-server
```

Language server for bash, written using tree sitter in typescript.
]],
  },
}

-- Fonction pour afficher automatiquement vim.lsp.buf.hover
local function setup_hover_on_cursor()
  local timer = vim.loop.new_timer()
  local hover_debounce = 300 -- Délai en ms pour limiter les appels

  vim.api.nvim_create_autocmd("CursorMovedI", {
    group = vim.api.nvim_create_augroup("LspHoverOnCursor", { clear = true }),
    callback = function()
      if timer:is_active() then
        timer:stop()
      end

      timer:start(
        hover_debounce,
        0,
        vim.schedule_wrap(function()
          local clients = vim.lsp.get_clients { bufnr = vim.api.nvim_get_current_buf() }
          if #clients > 0 then
            vim.lsp.buf.hover()
          end
        end)
      )
    end,
  })

  -- Keymap pour aller au diagnostic suivant
  vim.keymap.set("i", "<Alt-u>", function()
    local current_line = vim.api.nvim_win_get_cursor(0)[1]
    local diagnostics = vim.diagnostic.get(0) -- Récupère tous les diagnostics du buffer actuel

    -- Filtre les diagnostics qui se trouvent après la ligne courante
    local next_diag = nil
    for _, diag in ipairs(diagnostics) do
      if diag.lnum > current_line then
        next_diag = diag
        break
      end
    end

    -- Si un diagnostic suivant est trouvé, déplace le curseur à sa position
    if next_diag then
      vim.api.nvim_win_set_cursor(0, { next_diag.lnum + 1, next_diag.col }) -- Lnum est 0-indexé, on ajoute 1 pour 1-indexer
      -- Facultatif: afficher les détails du diagnostic dans une fenêtre flottante
      vim.diagnostic.open_float(next_diag.bufnr, { lnum = next_diag.lnum })
    else
      print "Aucun diagnostic suivant trouvé"
    end
  end, { noremap = true, silent = true, desc = "Aller au diagnostic suivant" })

  -- Arrêtez le timer lors de la fermeture de Neovim pour éviter les erreurs
  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = vim.api.nvim_create_augroup("LspHoverTimerCleanup", { clear = true }),
    callback = function()
      if timer:is_active() then
        timer:stop()
      end
      timer:close()
    end,
  })
end

-- Active la fonction pour les buffers LSP actifs
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    setup_hover_on_cursor()
  end,
})
