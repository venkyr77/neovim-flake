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
