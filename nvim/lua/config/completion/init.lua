local cmp = require("cmp")

cmp.setup({
  mapping = {
    ["<Down>"] = cmp.mapping.select_next_item({ behavior = "select" }),
    ["<Up>"] = cmp.mapping.select_prev_item({ behavior = "select" }),
    ["<Tab>"] = cmp.mapping.confirm({ select = true }),
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
    ["<C-Space>"] = cmp.mapping.complete({}),
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
  },
  sources = {
    { name = "buffer" },
    { name = "nvim_lsp" },
    { name = "path" },
  },
})
