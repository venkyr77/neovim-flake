require("catppuccin").setup({
  flavor = "mocha",
  integrations = {
    which_key = true,
  },
  term_colors = true,
})

vim.cmd.colorscheme("catppuccin")
