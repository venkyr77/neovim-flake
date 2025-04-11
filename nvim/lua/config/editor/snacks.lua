require("snacks").setup({
  explorer = { enabled = true },
  indent = {
    enabled = true,
    scope = { enabled = false },
  },
  notifier = { enabled = true },
  picker = {
    enabled = true,
    sources = {
      explorer = {
        hidden = true,
        win = {
          input = { keys = { ["<Esc>"] = "" } },
          list = { keys = { ["<Esc>"] = "" } },
        },
      },
      files = {
        layout = { fullscreen = true },
      },
      grep = {
        layout = { fullscreen = true },
      },
    },
    ui_select = true,
  },
  scroll = { enabled = true },
  words = { enabled = true },
})
