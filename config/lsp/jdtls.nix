{pkgs, ...}: let
  inherit (pkgs.lib.strings) hasSuffix;

  vscode-java-debug = "${pkgs.vscode-extensions.vscjava.vscode-java-debug}/share/vscode/extensions/vscjava.vscode-java-debug";
  # https://github.com/microsoft/vscode-java-test/issues/1759
  # custom fetch until nixpkgs uses 43.2(43.2 is in pre-release)
  vscode-java-test = "${pkgs.vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "vscode-java-test";
      publisher = "vscjava";
      version = "0.43.0";
      sha256 = "sha256-EM0S1Y4cRMBCRbAZgl9m6fIhANPrvdGVZXOLlDLnVWo=";
    };
  }}/share/vscode/extensions/vscjava.vscode-java-test";

  getJars = plugin: map (jar: "${plugin}/server/${jar}") (builtins.attrNames (builtins.readDir "${plugin}/server"));

  bundles =
    builtins.filter
    # https://github.com/mfussenegger/nvim-jdtls/issues/746
    (
      jar:
        !(
          hasSuffix "com.microsoft.java.test.runner-jar-with-dependencies.jar" jar
          || hasSuffix "jacocoagent.jar" jar
        )
    )
    (
      builtins.concatLists [
        (getJars vscode-java-debug)
        (getJars vscode-java-test)
      ]
    );

  bundles_lua_table = "{${builtins.concatStringsSep "," (builtins.map (b: "\"${b}\"") bundles)}}";
in
  #lua
  ''
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "java" },
      callback = function(_)
        local jdtls = require("jdtls")

        local root_dir = jdtls.setup.find_root({ "mvnw", "gradlew", ".git" })

        local cmd = {
          "${pkgs.lib.getExe pkgs.jdt-language-server}",
          "--jvm-arg=-javaagent:${pkgs.lombok}/share/java/lombok.jar",
          "-configuration",
          vim.fn.stdpath("cache") .. "/jdtls/config",
          "-data",
          vim.fn.stdpath("cache") .. "/jdtls/workspace/" .. vim.fn.fnamemodify(root_dir, ":p:h:t"),
        }

        local init_options = {
          bundles = ${bundles_lua_table},
          extendedClientCapabilities = vim.tbl_extend(
            "force",
            {},
            jdtls.extendedClientCapabilities,
            { resolveAdditionalTextEditsSupport = true }
          ),
        }

        local settings = {
          java = {
            completion = { enabled = true },
            configuration = {
              runtimes = {
                {
                  name = "JavaSE-1.8",
                  path = vim.fn.fnamemodify("${pkgs.jdk8}/lib/openjdk", ":p"),
                },
                {
                  name = "JavaSE-11",
                  path = vim.fn.fnamemodify("${pkgs.jdk11}/lib/openjdk", ":p"),
                },
                {
                  name = "JavaSE-17",
                  path = vim.fn.fnamemodify("${pkgs.jdk17}/lib/openjdk", ":p"),
                  default = true,
                },
                {
                  name = "JavaSE-21",
                  path = vim.fn.fnamemodify("${pkgs.jdk21}/lib/openjdk", ":p"),
                },
              },
            },
            contentProvider = { preferred = "fernflower" },
            eclipse = { downloadSources = true },
            inlayHints = { parameterNames = { enabled = "all" } },
            signatureHelp = { enabled = true },
            sources = {
              organizeImports = {
                starThreshold = 9999,
                staticStarThreshold = 9999,
              },
            },
          },
        }

        jdtls.start_or_attach({
          capabilities = client_capabilities,
          cmd = cmd,
          init_options = init_options,
          on_attach = function(client, buffer)
            default_on_attach(client, buffer)
            require("which-key").add({
              {
                "<leader>ltc",
                buffer = buffer,
                function()
                  jdtls.test_class({ config_overrides = { shortenCommandLine = "argfile" } })
                end,
                desc = "[t]est [c]lass",
              },
              {
                "<leader>ltm",
                buffer = buffer,
                function()
                  jdtls.test_nearest_method({ config_overrides = { shortenCommandLine = "argfile" } })
                end,
                desc = "[t]est nearest [m]ethod",
              },
            })
          end,
          root_dir = root_dir,
          settings = settings,
        })
      end,
    })
  ''
