local lzn = require("lz.n")

lzn.load({
  "LuaSnip",
  lazy = true,
  after = function()
    require("luasnip").setup({})
  end,
})

lzn.load({
  "friendly-snippets",
  lazy = true,
  after = function()
    require("luasnip.loaders.from_vscode").lazy_load()
  end,
})

lzn.load({
  "lspkind.nvim",
  lazy = true,
  after = function()
    require("lspkind").setup()
  end,
})

lzn.load({
  "blink.cmp",
  lazy = true,
  before = function()
    lzn.trigger_load("LuaSnip")
    lzn.trigger_load("friendly-snippets")
    lzn.trigger_load("lspkind.nvim")
  end,
  after = function()
    require("blink.cmp").setup({
      completion = {
        list = {
          selection = { auto_insert = false, preselect = false },
        },
        menu = {
          draw = {
            columns = {
              { "label", "label_description", gap = 1 },
              { "kind_icon", "kind", gap = 1 },
              { "source_name" },
            },
            components = {
              kind_icon = {
                text = function(ctx)
                  local icon = ctx.kind_icon

                  if vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                    if dev_icon then
                      icon = dev_icon
                    end
                  else
                    icon = require("lspkind").symbolic(ctx.kind, { mode = "symbol" })
                  end

                  return icon .. ctx.icon_gap
                end,
              },
              source_name = {
                text = function(ctx)
                  local source_to_text = {
                    Buffer = "[Buffer]",
                    LSP = "[LSP]",
                    Path = "[Path]",
                    Snippets = "[LuaSnip]",
                  }

                  return source_to_text[ctx.source_name]
                end,
              },
            },
          },
        },
        documentation = { auto_show = true, auto_show_delay_ms = 500 },
      },
      keymap = { preset = "enter" },
      signature = { enabled = true },
      snippets = { preset = "luasnip" },
    })
  end,
})
