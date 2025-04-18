{pkgs, ...}:
# lua
''
  local lzn = require("lz.n")

  lzn.load({
    "lazydev.nvim",
    lazy = true,
    after = function()
      require("lazydev").setup()
    end
  })

  lzn.load({
    "nvim-jdtls",
    lazy = true,
  })

  lzn.load({
    "sonarlint.nvim",
    lazy = false,
  })

  lzn.load({
    "nvim-lspconfig",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    before = function()
      lzn.trigger_load("blink.cmp")
    end,
    after = function()
      local virtual_lines_format = function(diagnostic)
        return string.format("%s (%s)", diagnostic.message, diagnostic.source)
      end

      vim.diagnostic.config({
        virtual_lines = { format = virtual_lines_format },
      })

      local client_capabilities = require("blink.cmp").get_lsp_capabilities()

      local goto_picker_opts = {
        layout = { fullscreen = true },
      }

      local jump_to_diagnostic = function(count)
        if not vim.b.current_min_severity then
          vim.b.current_min_severity = vim.diagnostic.severity.HINT
        end

        vim.diagnostic.jump({
          count = count,
          float = false,
          severity = { min = vim.b.current_min_severity },
        })
      end

      local refresh_diagnostic_severity = function()
        vim.diagnostic.config({
          virtual_lines = {
            format = virtual_lines_format,
            severity = { min = vim.b.current_min_severity },
          },
          underline = {
            severity = { min = vim.b.current_min_severity },
          },
        })
      end

      local default_on_attach = function(client, buffer)
        require("which-key").add({
          {
            "<leader>g",
            buffer = buffer,
            desc = "+[g]oto(lsp)",
            icon = " ",
          },
          {
            "<leader>gd",
            buffer = buffer,
            function()
              Snacks.picker.lsp_definitions(goto_picker_opts)
            end,
            desc = "[d]efinitions",
          },
          {
            "<leader>gD",
            buffer = buffer,
            function()
              Snacks.picker.lsp_declarations(goto_picker_opts)
            end,
            desc = "[D]eclarations",
          },
          {
            "<leader>gi",
            buffer = buffer,
            function()
              Snacks.picker.lsp_implementations(goto_picker_opts)
            end,
            desc = "[i]mplementations",
          },
          {
            "<leader>gr",
            buffer = buffer,
            function()
              Snacks.picker.lsp_references(goto_picker_opts)
            end,
            desc = "[r]eferences",
          },
          {
            "<leader>gt",
            buffer = buffer,
            function()
              Snacks.picker.lsp_type_definitions(goto_picker_opts)
            end,
            desc = "[t]ype definitions",
          },
          {
            "<leader>l",
            buffer = buffer,
            desc = "+[l]sp",
          },
          {
            "<leader>ld",
            buffer = buffer,
            desc = "+[d]iagnostics",
          },
          {
            "<leader>lda",
            buffer = buffer,
            function()
              vim.b.current_min_severity = vim.diagnostic.severity.HINT
              refresh_diagnostic_severity()
            end,
            desc = "[a]ll",
          },
          {
            "<leader>lde",
            buffer = buffer,
            function()
              vim.b.current_min_severity = vim.diagnostic.severity.ERROR
              refresh_diagnostic_severity()
            end,
            desc = "[e]rror",
          },
          {
            "<leader>ldn",
            buffer = buffer,
            function()
              jump_to_diagnostic(1)
            end,
            desc = "[n]ext",
          },
          {
            "<leader>ldp",
            buffer = buffer,
            function()
              jump_to_diagnostic(-1)
            end,
            desc = "[p]rev",
          },
          {
            "<leader>ldt",
            buffer = buffer,
            function()
              vim.diagnostic.enable(not vim.diagnostic.is_enabled())
            end,
            desc = "[t]oggle",
            icon = " ",
          },
        })

        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
          vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
        end
      end

      local lspconfig = require("lspconfig")

      lspconfig.lua_ls.setup({
        capabilities = client_capabilities,
        on_attach = default_on_attach,
      })

      lspconfig.nixd.setup({
        capabilities = client_capabilities,
        on_attach = default_on_attach,
      })

      lzn.trigger_load("lazydev.nvim")

      lzn.trigger_load("nvim-jdtls")
      ${import ./jdtls.nix {inherit pkgs;}}

      require("sonarlint").setup({
        server = {
          cmd = {
            "${pkgs.lib.getExe pkgs.sonarlint-ls}",
            "-stdio",
            "-analyzers",
            "${pkgs.sonarlint-ls}/share/plugins/sonarjava.jar",
          },
        },
        filetypes = { "java" },
      })
    end,
  })
''
