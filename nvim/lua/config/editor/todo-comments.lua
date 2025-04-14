require("lz.n").load({
  "todo-comments.nvim",
  event = { "BufReadPost", "BufWritePost", "BufNewFile" },
  after = function()
    require("todo-comments").setup({})
  end,
})
