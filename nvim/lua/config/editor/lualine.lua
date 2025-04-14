require("lz.n").load({
  "lualine.nvim",
  event = { "DeferredUIEnter" },
  after = function()
    require("lualine").setup({
      extensions = {
        "neo-tree",
      },
      options = {
        component_separators = { "", "" },
        section_separators = { "", "" },
        theme = "catppuccin",
      },
      sections = {
        lualine_a = {
          {
            "mode",
            icons_enabled = true,
            separator = { left = "▎", right = "" },
          },
          {
            "",
            draw_empty = true,
            separator = { left = "", right = "" },
          },
        },
        lualine_b = {
          {
            "filetype",
            colored = true,
            icon = { align = "left" },
            icon_only = true,
          },
          {
            "filename",
            separator = { right = "" },
            symbols = { modified = " ", readonly = " " },
          },
          {
            "",
            draw_empty = true,
            separator = { left = "", right = "" },
          },
        },
        lualine_c = {
          {
            "diff",
            colored = false,
            diff_color = { added = "DiffAdd", modified = "DiffChange", removed = "DiffDelete" },
            separator = { right = "" },
            symbols = { added = "+", modified = "~", removed = "-" },
          },
        },
        lualine_x = {
          {
            function()
              local bufnr = vim.api.nvim_get_current_buf()
              local clients = vim.lsp.get_clients({ bufnr = bufnr })

              if vim.tbl_isempty(clients) then
                return "No Active LSP"
              end

              local active_clients = {}
              for _, client in ipairs(clients) do
                table.insert(active_clients, client.name)
              end

              return table.concat(active_clients, ", ")
            end,
            icon = " ",
            separator = { left = "" },
          },
          {
            "diagnostics",
            always_visible = false,
            colored = true,
            diagnostics_color = {
              color_error = { fg = "red" },
              color_warn = { fg = "yellow" },
              color_info = { fg = "cyan" },
            },
            sources = { "nvim_lsp", "nvim_diagnostic" },
            symbols = { error = "󰅙  ", warn = "  ", info = "  ", hint = "󰌵 " },
            update_in_insert = false,
          },
        },
        lualine_y = {
          {
            "",
            draw_empty = true,
            separator = { left = "", right = "" },
          },
          {
            "searchcount",
            maxcount = 999,
            separator = { left = "" },
            timeout = 120,
          },
          {
            "branch",
            icon = " •",
            separator = { left = "" },
          },
        },
        lualine_z = {
          {
            "",
            draw_empty = true,
            separator = { left = "", right = "" },
          },
          {
            "progress",
            separator = { left = "" },
          },
          {
            "location",
          },
          {
            "fileformat",
            color = { fg = "black" },
            symbols = { dos = "", mac = "", unix = "" },
          },
        },
      },
    })
  end,
})
