require("lz.n").load({
  "nvim-nio",
  lazy = false,
})

require("lz.n").load({
  "nvim-dap",
  lazy = false,
})

require("lz.n").load({
  "nvim-dap-ui",
  lazy = false,
  after = function()
    local dap, dapui = require("dap"), require("dapui")
    dapui.setup()
    dap.listeners.after.event_initialized["dapui_config"] = function()
      require("dapui").open()
    end
  end,
})
