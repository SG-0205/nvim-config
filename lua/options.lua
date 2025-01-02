require "nvchad.options"

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
--
-- Ajouter une commande pour insérer un message de copyright
vim.api.nvim_create_user_command("AddCopyright", function()
  -- Définir le message de copyright
  local year = os.date "%Y"
  local author = "Samuel Goldenberg" -- Remplacez par votre nom
  local copyright_message = string.format(
    [[
/*
 * Copyright (C) %s %s
 * Goldenberg & Catalano WM
 * All rights reserved.
 */
]],
    year,
    author
  )

  -- Insérer le message en haut du fichier
  vim.api.nvim_buf_set_lines(0, 0, 0, false, vim.split(copyright_message, "\n"))
end, { desc = "Ajouter un message de copyright en haut du fichier" })
