return {
  {
    "nvim-lua/plenary.nvim",
  },
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    opts = require "configs.conform",
  },
  {
    "bfrg/vim-c-cpp-modern",
    event = "LspAttach",
  },
  {
    "MysticalDevil/inlay-hints.nvim",
    event = "LspAttach",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require("inlay-hints").setup()
      require "configs.hints"
    end,
  },
  {
    "rachartier/tiny-code-action.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim" },
    },
    event = "LspAttach",
    config = function()
      require("tiny-code-action").setup()
    end,
  },
  -- {
  --   "mfussenegger/nvim-lint",
  --   event = "InsertEnter",
  --   config = function()
  --     require "configs.lint"
  --   end,
  -- },
  { "echasnovski/mini.nvim", version = false },
  -- These are some examples, uncomment them if you want to see them work!
  { "cacharle/c_formatter_42.vim" },
  {
    "Diogo-ss/42-C-Formatter.nvim",
    cmd = "CFormat42",
    config = function()
      local formatter = require "42-formatter"
      formatter.setup {
        formatter = "c_formatter_42",
        filetypes = { c = true, h = true },
      }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "cpp",
      },
    },
  },
  {
    "RishabhRD/nvim-lsputils",
    lazy = false,
  },
  {
    "nvimtools/none-ls.nvim",
    config = function()
      require("null-ls").setup()
    end,
    requires = { "nvim-lua/plenary.nvim" },
    lazy = false,
  },
  { "jesseduffield/lazygit" },
  {
    "Diogo-ss/42-header.nvim",
    cmd = { "Stdheader" },
    keys = { "<F1>" },
    opts = {
      default_map = true, -- Default mapping <F1> in normal mode.
      auto_update = true, -- Update header when saving.
      user = "sgoldenb", -- Your user.
      mail = "sgoldenb@student.42.fr", -- Your mail.
      -- add other options.
    },
    config = function(_, opts)
      require("42header").setup(opts)
    end,
  },
  -- {
  --   "deathbeam/autocomplete.nvim",
  --   event = "VeryLazy",
  --   config = function()
  --     -- LSP signature help
  --     require("autocomplete.signature").setup {
  --       border = nil, -- Signature help border style
  --       width = 80, -- Max width of signature window
  --       height = 25, -- Max height of signature window
  --       debounce_delay = 100,
  --     }
  --
  --     -- buffer autocompletion with LSP and Tree-sitter
  --     require("autocomplete.buffer").setup {
  --       border = nil, -- Documentation border style
  --       entry_mapper = nil, -- Custom completion entry mapper
  --       debounce_delay = 100,
  --     }
  --
  --     -- cmdline autocompletion
  --     require("autocomplete.cmd").setup {
  --       mappings = {
  --         accept = "<C-y>",
  --         reject = "<C-e>",
  --         complete = "<C-space>",
  --         next = "<C-n>",
  --         previous = "<C-p>",
  --       },
  --       border = nil, -- Cmdline completion border style
  --       columns = 5, -- Number of columns per row
  --       rows = 0.3, -- Number of rows, if < 1 then its fraction of total vim lines, if > 1 then its absolute number
  --       close_on_done = true, -- Close completion window when done (accept/reject)
  --       debounce_delay = 100,
  --     }
  --   end,
  -- },
  {
    "mfussenegger/nvim-dap",
    config = function()
      require "configs.dap"
    end,
    event = "VeryLazy",
  },
  {
    "mfussenegger/nvim-lint",
    config = function()
      require "configs.lint"
    end,
    event = { "BufReadPre", "BufNewFile" },
  },
  {
    "terryma/vim-multiple-cursors",
    opts = {
      multi_cursor_use_default_mapping = 0,
      multi_cursor_start_word_key = "<C-n>",
      multi_cursor_select_all_word_key = "<A-n>",
      multi_cursor_start_key = "g<C-n>",
      multi_cursor_select_all_key = "g<A-n>",
      multi_cursor_next_key = "<C-n>",
      multi_cursor_prev_key = "<C-p>",
      multi_cursor_skip_key = "<C-x>",
      multi_cursor_quit_key = "<Esc>",
    },
  },
  {
    "folke/trouble.nvim",
    lazy = false,
    vim.keymap.set("n", "<A-r>", function()
      local trouble = require "trouble"
      if vim.bo.filetype == "Trouble" then
        vim.cmd "wincmd p" -- Revenir à la fenêtre précédente
      else
        trouble.toggle "diagnostics"
      end
    end, { desc = "Toggle Trouble focus" }),

    opts = {
      function()
        require "configs.trouble"
      end,
    }, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
  -- Lua
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    lazy = false,
    opts = {
      -- add any custom options here
    },
    keys = {
      -- load the session for the current directory
      vim.keymap.set("n", "<leader>qs", function()
        require("persistence").load()
      end, { desc = "Load session." }),

      -- select a session to load
      vim.keymap.set("n", "<leader>qS", function()
        require("persistence").select()
      end, { desc = "Select session and load." }),

      -- load the last session
      vim.keymap.set("n", "<leader>ql", function()
        require("persistence").load { last = true }
      end, { desc = "Load latest session." }),

      -- stop Persistence => session won't be saved on exit
      vim.keymap.set("n", "<leader>qd", function()
        require("persistence").stop()
      end, { desc = "Stop session recording." }),
    },
  },
  {
    "folke/which-key.nvim",
    lazy = false,
    event = "VeryLazy",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      preset = "modern",
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show { global = false }
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
}
