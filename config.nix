{
  lib,
  pkgs,
  ...
}: {
  extraBinPath = [
    # formatters
    pkgs.alejandra
    pkgs.stylua
    # language servers
    pkgs.lua-language-server
    pkgs.nixd
    #linters
    pkgs.luajitPackages.luacheck
    pkgs.statix
  ];

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
        }
      )
    ) (import ./npins/default.nix)
    ++ [
      ./nvim
    ];
}
