{pkgs, ...}:
# lua
''
  require("lz.n").load({
  "conform.nvim",
  event = { "BufWritePre" },
  after = function()
    local conform = require("conform")

    conform.setup({
      formatters = {
        denofmt_md = {
          command = "${pkgs.lib.getExe pkgs.deno}",
          args = {
            "fmt",
            "-",
            "--ext",
            "md",
          },
        },
      },
      formatters_by_ft = {
        java = { lsp_format = "prefer" },
        lua = { "stylua" },
        markdown = { "denofmt_md" },
        nix = { "alejandra" },
      },
    })

    require("which-key").add({
      { "<leader>c", desc = "+[c]onform(format)" },
      {
        "<leader>cb",
        function()
          conform.format()
        end,
        desc = "[b]uffer",
      },
      {
        "<leader>cm",
        -- https://github.com/stevearc/conform.nvim/issues/92#issuecomment-2069915330
        function()
          local hunks = require("gitsigns").get_hunks()
          for i = #hunks, 1, -1 do
            local hunk = hunks[i]
            if hunk ~= nil and hunk.type ~= "delete" then
              local start = hunk.added.start
              local last = start + hunk.added.count
              -- nvim_buf_get_lines uses zero-based indexing -> subtract from last
              local last_hunk_line = vim.api.nvim_buf_get_lines(0, last - 2, last - 1, true)[1]
              local range = { start = { start, 0 }, ["end"] = { last - 1, last_hunk_line:len() } }
              conform.format({ range = range })
            end
          end
        end,
        desc = "[m]odifications",
      },
    })
  end,
  })
''
