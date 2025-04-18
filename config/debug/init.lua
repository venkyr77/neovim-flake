require("lz.n").load({
  "nvim-nio",
  lazy = false,
})

require("lz.n").load({
  "nvim-dap",
  lazy = false,
  after = function()
    require("dap").listeners.after.event_initialized["dapui_config"] = function()
      require("neo-tree.command").execute({ action = "close" })
      require("dapui").open()
    end
  end,
})

require("lz.n").load({
  "nvim-dap-ui",
  lazy = false,
  after = function()
    require("dapui").setup()
  end,
})
