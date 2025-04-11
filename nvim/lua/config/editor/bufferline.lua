require("bufferline").setup({
  options = {
    close_command = function(n)
      Snacks.bufdelete(n)
    end,
    right_mouse_command = function(n)
      Snacks.bufdelete(n)
    end,
    offsets = {
      {
        filetype = "snacks_layout_box",
        highlight = "Directory",
        separator = true,
        text = "󰙅  File Explorer",
      },
    },
  },
})
