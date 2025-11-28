{
  lib,
  pkgs,
  ...
}: {
  extraBinPath = let
    formatters = [
      pkgs.alejandra
      pkgs.stylua
    ];

    language_servers = [
      pkgs.lua-language-server
      pkgs.nixd
    ];

    linters = [
      pkgs.luajitPackages.luacheck
      (
        pkgs.statix.overrideAttrs (_old: rec {
          src = pkgs.fetchFromGitHub {
            owner = "oppiliappan";
            repo = "statix";
            rev = "master";
            hash = "sha256-duH6Il124g+CdYX+HCqOGnpJxyxOCgWYcrcK0CBnA2M=";
          };

          cargoDeps = pkgs.rustPlatform.importCargoLock {
            lockFile = src + "/Cargo.lock";
            allowBuiltinFetchGit = true;
          };
        })
      )
    ];

    tools = [
      pkgs.ripgrep
    ];
  in
    formatters ++ language_servers ++ linters ++ tools;

  initLua =
    # lua
    ''
      ${builtins.readFile ./config/options.lua}
      ${builtins.readFile ./config/editor/colorscheme.lua}
      ${builtins.readFile ./config/editor/which-key.lua}
      ${builtins.readFile ./config/editor/nui.lua}
      ${builtins.readFile ./config/editor/nvim-web-devicons.lua}
      ${builtins.readFile ./config/editor/plenary.lua}
      ${builtins.readFile ./config/editor/neo-tree.lua}
      ${builtins.readFile ./config/editor/snacks.lua}
      ${builtins.readFile ./config/editor/auto-save.lua}
      ${builtins.readFile ./config/editor/bufferline.lua}
      ${builtins.readFile ./config/editor/gitsigns.lua}
      ${builtins.readFile ./config/editor/guess-indent.lua}
      ${builtins.readFile ./config/editor/lualine.lua}
      ${builtins.readFile ./config/editor/noice.lua}
      ${builtins.readFile ./config/editor/nvim-autopairs.lua}
      ${builtins.readFile ./config/editor/rainbow-delimiters.lua}
      ${builtins.readFile ./config/editor/smartyank.lua}
      ${builtins.readFile ./config/editor/todo-comments.lua}
      ${builtins.readFile ./config/editor/treesitter.lua}
      ${builtins.readFile ./config/completion/init.lua}
      ${builtins.readFile ./config/debug/init.lua}
      ${import ./config/format {inherit pkgs;}}
      ${import ./config/lsp {inherit pkgs;}}
      ${builtins.readFile ./config/lint/init.lua}
    '';

  plugins = let
    pins = import ./npins/default.nix;

    mkPlugin = pname: pin:
      pin
      // {
        inherit pname;
        version = pin.revision;
      };
  in {
    opt =
      lib.mapAttrsToList mkPlugin (lib.filterAttrs (pname: _: pname != "lz.n") pins);
    start =
      [
        pkgs.vimPlugins.nvim-treesitter.withAllGrammars
      ]
      ++ lib.mapAttrsToList mkPlugin (lib.filterAttrs (pname: _: pname == "lz.n") pins);
  };
}
