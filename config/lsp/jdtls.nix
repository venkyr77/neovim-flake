{pkgs, ...}: let
  inherit (pkgs.lib.strings) hasSuffix;

  vscode-java-debug = "${pkgs.vscode-extensions.vscjava.vscode-java-debug}/share/vscode/extensions/vscjava.vscode-java-debug";
  vscode-java-test = "${pkgs.vscode-extensions.vscjava.vscode-java-test}/share/vscode/extensions/vscjava.vscode-java-test";

  getJars = plugin: map (jar: "${plugin}/${jar}") (builtins.attrNames (builtins.readDir "${plugin}/server"));

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
                  path = "${pkgs.jdk8}",
                },
                {
                  name = "JavaSE-11",
                  path = "${pkgs.jdk11}",
                },
                {
                  name = "JavaSE-17",
                  path = "${pkgs.jdk17}",
                  default = true,
                },
                {
                  name = "JavaSE-21",
                  path = "${pkgs.jdk21}",
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
          on_attach = on_attach,
          root_dir = root_dir,
          settings = settings,
        })
      end,
    })
  ''
