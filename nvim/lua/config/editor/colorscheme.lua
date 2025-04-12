require("lz.n").load({
  "catppuccin.nvim",
  colorscheme = "catppuccin",
  after = function()
    require("catppuccin").setup({
      custom_highlights = function(colors)
        return {
          RainbowRed = { blend = 0, fg = colors.red },
          RainbowYellow = { blend = 0, fg = colors.yellow },
          RainbowBlue = { blend = 0, fg = colors.blue },
          RainbowOrange = { blend = 0, fg = colors.peach },
          RainbowGreen = { blend = 0, fg = colors.green },
          RainbowViolet = { blend = 0, fg = colors.mauve },
          RainbowCyan = { blend = 0, fg = colors.teal },
        }
      end,
      flavor = "mocha",
      integrations = {
        noice = true,
        snacks = { enabled = true },
        which_key = true,
      },
      term_colors = true,
    })
  end,
})

vim.cmd.colorscheme("catppuccin")
