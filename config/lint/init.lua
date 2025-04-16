require("lz.n").load({
  "nvim-lint",
  event = { "BufReadPost", "BufWritePost", "BufNewFile" },
  after = function()
    local lint = require("lint")
    lint.linters_by_ft = {
      lua = { "luacheck" },
      nix = { "statix" },
    }
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      callback = function()
        lint.try_lint()
      end,
      group = lint_augroup,
    })
  end,
})
