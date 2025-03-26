require "nvchad.mappings"

-- add yours here

local function is_function_or_class(node)
  if not node then
    return false
  end
  local node_type = node:type()
  return node_type == "function" or node_type == "method" or node_type == "class" or node_type == "struct"
end

local map = vim.keymap.set

local keys = {
  vim.keymap.set("n", "<leader>ca", function()
    require("tiny-code-action").code_action()
  end, { noremap = true, silent = true }),

  map("n", ";", ":", { desc = "CMD enter command mode" }),
  map("i", "jk", "<ESC>"),

  -- Keymaps pour le mode insertion
  vim.keymap.set("i", "<A-w>", "<C-p>", { desc = "Monte dans le sélecteur de suggestions" }),
  vim.keymap.set("i", "<A-s>", "<C-n>", { desc = "Descend dans le sélecteur de suggestions" }),
  vim.keymap.set("i", "<A-a>", "<C-o>^", { desc = "Déplace le curseur au début de la ligne" }),
  vim.keymap.set("i", "<A-d>", "<C-o>$", { desc = "Déplace le curseur à la fin de la ligne" }),

  -- Déplacement vers les éléments structuraux (LSP ou navigation)
  vim.keymap.set("i", "<A-e>", function()
    vim.cmd "stopinsert" -- Sort du mode insertion
    local ts_utils = require "nvim-treesitter.ts_utils"
    local node = ts_utils.get_node_at_cursor()
    while node and not is_function_or_class(node) do
      node = node:parent()
    end
    if node then
      vim.fn.cursor(node:start()) -- Position au début de l'élément
    end
  end, { desc = "Passe en mode normal et retourne au début de l'élément précédent", noremap = true }),

  vim.keymap.set("i", "<A-f>", function()
    vim.cmd "stopinsert" -- Sort du mode insertion
    local ts_utils = require "nvim-treesitter.ts_utils"
    local node = ts_utils.get_node_at_cursor()
    while node and not is_function_or_class(node) do
      node = node:next_sibling()
    end
    if node then
      vim.fn.cursor(node:start()) -- Position au début de l'élément suivant
    end
  end, { desc = "Passe en mode normal et avance au début de l'élément suivant", noremap = true }),
}

return keys
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
