require("lz.n").load({
  "noice.nvim",
  event = { "DeferredUIEnter" },
  after = function()
    require("noice").setup({
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        signature = { enabled = false },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        inc_rename = false,
        long_message_to_split = true,
        lsp_doc_border = false,
      },
    })
  end,
})
