local lzn = require("lz.n")

lzn.load({
  "neo-tree.nvim",
  lazy = false,
  before = function()
    lzn.trigger_load("nui.nvim")
    lzn.trigger_load("nvim-web-devicons")
    lzn.trigger_load("plenary.nvim")
  end,
  after = function()
    require("neo-tree").setup({
      default_component_configs = {
        indent = {
          with_expanders = true,
        },
      },
      enable_cursor_hijack = true,
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          never_show = {
            ".git",
          },
        },
        follow_current_file = {
          enabled = true,
          leave_dirs_open = true,
        },
        group_empty_dirs = true,
        scan_mode = "deep",
      },
    })
    require("which-key").add({
      {
        "\\",
        ":Neotree toggle<CR>",
        desc = "[N]eotree [t]oggle",
      },
    })
  end,
})
