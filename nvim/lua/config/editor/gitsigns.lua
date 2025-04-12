local gitsigns = require("gitsigns")
local wk = require("which-key")

gitsigns.setup({
  on_attach = function(buffer)
    wk.add({
      {
        "<leader>h",
        buffer = buffer,
        desc = "+[h]unk(gitsigns)",
      },
      {
        "<leader>ht",
        buffer = buffer,
        desc = "+[t]oggle",
        icon = " ",
      },
      {
        "<leader>hb",
        function()
          gitsigns.blame_line({ full = true })
        end,
        buffer = buffer,
        desc = "[b]lame line",
      },
      {
        "<leader>hn",
        function()
          gitsigns.nav_hunk("next")
        end,
        buffer = buffer,
        desc = "[n]ext",
      },
      {
        "<leader>hp",
        function()
          gitsigns.nav_hunk("prev")
        end,
        buffer = buffer,
        desc = "[p]rev",
      },
      {
        "<leader>hr",
        function()
          gitsigns.reset_hunk()
        end,
        buffer = buffer,
        desc = "[r]eset",
      },
      {
        "<leader>hR",
        function()
          gitsigns.reset_buffer()
        end,
        buffer = buffer,
        desc = "[R]eset buffer",
      },
      {
        "<leader>hs",
        function()
          gitsigns.stage_hunk()
        end,
        buffer = buffer,
        desc = "[s]tage",
      },
      {
        "<leader>hS",
        function()
          gitsigns.stage_buffer()
        end,
        buffer = buffer,
        desc = "[S]tage buffer",
      },
      {
        "<leader>htb",
        function()
          gitsigns.toggle_current_line_blame()
        end,
        buffer = buffer,
        desc = "[b]lame",
      },
      {
        "<leader>hu",
        function()
          gitsigns.undo_stage_hunk()
        end,
        buffer = buffer,
        desc = "[u]ndo stage",
      },
      {
        "<leader>hv",
        function()
          gitsigns.preview_hunk()
        end,
        buffer = buffer,
        desc = "[v]iew hunk",
      },
    })
  end,
})
