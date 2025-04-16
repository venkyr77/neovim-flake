require("lz.n").load({
  "which-key.nvim",
  lazy = false,
  after = function()
    require("which-key").setup({
      preset = "modern",
    })
  end,
})
