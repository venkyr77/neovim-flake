require("bufferline").setup({
  highlights = require("catppuccin.groups.integrations.bufferline").get(),
  options = {
    close_command = function(n)
      Snacks.bufdelete(n)
    end,
    indicator = { style = "underline" },
    offsets = {
      {
        filetype = "snacks_layout_box",
        highlight = "Directory",
        separator = true,
        text = "󰙅  File Explorer",
      },
    },
    right_mouse_command = "vertical sbuffer %d",
  },
})
