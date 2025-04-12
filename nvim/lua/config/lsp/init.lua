local lspconfig = require("lspconfig")
local snacks = require("snacks")
local wk = require("which-key")

local client_capabilities = vim.tbl_deep_extend(
  "force",
  {},
  vim.lsp.protocol.make_client_capabilities(),
  require("cmp_nvim_lsp").default_capabilities()
)

local goto_picker_opts = {
  layout = { fullscreen = true },
}

local on_attach = function(client, buffer)
  wk.add({
    {
      "<leader>g",
      buffer = buffer,
      desc = "+[g]oto(lsp)",
    },
    {
      "<leader>gd",
      buffer = buffer,
      function()
        snacks.picker.lsp_definitions(goto_picker_opts)
      end,
      desc = "[d]efinitions",
    },
    {
      "<leader>gD",
      buffer = buffer,
      function()
        snacks.picker.lsp_declarations(goto_picker_opts)
      end,
      desc = "[D]eclarations",
    },
    {
      "<leader>gi",
      buffer = buffer,
      function()
        snacks.picker.lsp_implementations(goto_picker_opts)
      end,
      desc = "[i]mplementations",
    },
    {
      "<leader>gr",
      buffer = buffer,
      function()
        snacks.picker.lsp_references(goto_picker_opts)
      end,
      desc = "[r]eferences",
    },
    {
      "<leader>gt",
      buffer = buffer,
      function()
        snacks.picker.lsp_type_definitions(goto_picker_opts)
      end,
      desc = "[t]ype definitions",
    },
  })

  if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
    vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
  end
end

lspconfig.lua_ls.setup({
  capabilities = client_capabilities,
  on_attach = on_attach,
})

lspconfig.nixd.setup({
  capabilities = client_capabilities,
  on_attach = on_attach,
})
