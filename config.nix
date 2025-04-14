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
      pkgs.statix
    ];
  in
    formatters ++ language_servers ++ linters;

  initLua =
    # lua
    ''
      require("config")
    '';

  plugins =
    [
      pkgs.vimPlugins.nvim-treesitter.withAllGrammars
    ]
    ++ lib.mapAttrsToList (
      pname: pin: (
        pin
        // {
          inherit pname;
          version = pin.revision;
          optional = builtins.elem pname [
            "auto-save.nvim"
            "blink.cmp"
            "bufferline.nvim"
            "catppuccin.nvim"
            "conform.nvim"
            "friendly-snippets"
            "lualine.nvim"
            "LuaSnip"
            "nvim-autopairs"
            "nvim-lspconfig"
            "noice.nvim"
          ];
        }
      )
    ) (import ./npins/default.nix)
    ++ [
      ./nvim
    ];
}
