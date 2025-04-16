require("lz.n").load({
  "snacks.nvim",
  lazy = false,
  after = function()
    require("snacks").setup({
      indent = {
        enabled = true,
        indent = {
          hl = {
            "RainbowRed",
            "RainbowYellow",
            "RainbowBlue",
            "RainbowOrange",
            "RainbowGreen",
            "RainbowViolet",
            "RainbowCyan",
          },
        },
        scope = { enabled = false },
      },
      notifier = { enabled = true },
      picker = {
        enabled = true,
        sources = {
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

    require("which-key").add({
      {
        "<leader>f",
        desc = "+[f]ind(snacks)",
        icon = " ",
      },
      {
        "<leader>ff",
        function()
          Snacks.picker.files()
        end,
        desc = "[f]iles",
      },
      {
        "<leader>fg",
        function()
          Snacks.picker.grep()
        end,
        desc = "[g]rep",
      },
      {
        "<leader>fG",
        function()
          Snacks.picker.grep({ hidden = true, ignored = true })
        end,
        desc = "[G]rep all(hidden and ignored) files",
      },
    })
  end,
})
