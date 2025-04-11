require("catppuccin").setup({
  flavor = "mocha",
  term_colors = true,
})

vim.cmd.colorscheme("catppuccin")

require("auto-save").setup({ debounce_delay = 100 })

require("bufferline").setup({
  options = {
    offsets = {
      {
        filetype = "snacks_layout_box",
        highlight = "Directory",
        separator = true,
        text = "󰙅  File Explorer",
      },
    },
  },
})

require("gitsigns").setup()

require("guess-indent").setup()

require("lualine").setup({
  extensions = {
    {
      filetypes = { "snacks_picker_input", "snacks_picker_list" },
      sections = {
        lualine_a = {
          function()
            return vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
          end,
        },
      },
    },
  },
  options = {
    component_separators = { "", "" },
    section_separators = { "", "" },
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

require("noice").setup({
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
  },
  presets = {
    bottom_search = true,
    command_palette = true,
    inc_rename = false,
    long_message_to_split = true,
    lsp_doc_border = false,
  },
})

require("nvim-autopairs").setup()

require("nvim-treesitter.configs").setup({
  auto_install = false,
  ensure_installed = {},
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = { enable = true },
  ignore_install = {},
  modules = {},
  sync_install = false,
})

require("smartyank").setup({ osc52 = { ssh_only = false } })

require("snacks").setup({
  explorer = { enabled = true },
  indent = {
    enabled = true,
    scope = { enabled = false },
  },
  notifier = { enabled = true },
  picker = {
    enabled = true,
    sources = {
      explorer = {
        hidden = true,
        win = {
          input = { keys = { ["<Esc>"] = "" } },
          list = { keys = { ["<Esc>"] = "" } },
        },
      },
      files = {
        layout = { fullscreen = true },
      },
      grep = {
        layout = { fullscreen = true },
      },
    },
    ui_select = true,
  },
  scroll = { enabled = true },
  words = { enabled = true },
})
