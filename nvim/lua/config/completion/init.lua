local cmp = require("cmp")
local luasnip = require("luasnip")

luasnip.setup({})
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  formatting = {
    format = require("lspkind").cmp_format({
      menu = {
        buffer = "[Buffer]",
        luasnip = "[Luasnip]",
        nvim_lsp = "[LSP]",
        path = "[Path]",
      },
      mode = "symbol_text",
    }),
  },
  mapping = {
    ["<Down>"] = cmp.mapping.select_next_item({ behavior = "select" }),
    ["<Up>"] = cmp.mapping.select_prev_item({ behavior = "select" }),
    ["<Tab>"] = cmp.mapping.confirm({ select = true }),
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
    ["<C-Space>"] = cmp.mapping.complete({}),
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  sources = {
    { name = "buffer" },
    { name = "lazydev" },
    { name = "luasnip" },
    { name = "nvim_lsp" },
    { name = "path" },
  },
})
