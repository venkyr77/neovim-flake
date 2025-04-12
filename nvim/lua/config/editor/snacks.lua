local snacks = require("snacks")
local wk = require("which-key")

snacks.setup({
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

wk.add({
  {
    "<leader>f",
    desc = "+[f]ind(snacks)",
  },
  {
    "<leader>ff",
    function()
      snacks.picker.files()
    end,
    desc = "[f]iles",
  },
  {
    "<leader>fg",
    function()
      snacks.picker.grep()
    end,
    desc = "[g]rep",
  },
  {
    "<leader>fG",
    function()
      snacks.picker.grep({ hidden = true, ignored = true })
    end,
    desc = "[G]rep all(hidden and ignored) files",
  },
  {
    "\\",
    function()
      snacks.explorer()
    end,
    desc = "toggle explorer",
  },
})
