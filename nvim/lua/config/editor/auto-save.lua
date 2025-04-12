require("lz.n").load({
  "auto-save.nvim",
  event = { "InsertLeave", "TextChanged" },
  after = function()
    require("auto-save").setup({ debounce_delay = 100 })
  end,
})
