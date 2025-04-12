local client_capabilities = vim.tbl_deep_extend(
  "force",
  {},
  vim.lsp.protocol.make_client_capabilities(),
  require("cmp_nvim_lsp").default_capabilities()
)

local lspconfig = require("lspconfig")

lspconfig.lua_ls.setup({
  capabilities = client_capabilities,
})

lspconfig.nixd.setup({
  capabilities = client_capabilities,
})
