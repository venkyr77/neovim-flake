require("catppuccin").setup({
  flavor = "mocha",
  term_colors = true,
})

vim.cmd.colorscheme("catppuccin")

require("auto-save").setup({
  debounce_delay = 100,
})

require("nvim-treesitter.configs").setup({
  auto_install = false,
  ensure_installed = {},
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
  ignore_install = {},
  modules = {},
  sync_install = false,
})

require("snacks").setup({
  explorer = {
    enabled = true,
  },
  indent = {
    enabled = true,
    scope = {
      enabled = false,
    },
  },
  notifier = {
    enabled = true,
  },
  picker = {
    enabled = true,
    sources = {
      explorer = {
        hidden = true,
        win = {
          input = {
            keys = {
              ["<Esc>"] = "",
            },
          },
          list = {
            keys = {
              ["<Esc>"] = "",
            },
          },
        },
      },
      files = {
        layout = {
          fullscreen = true,
        },
      },
      grep = {
        layout = {
          fullscreen = true,
        },
      },
    },
    ui_select = true,
  },
  words = {
    enabled = true,
  },
})
