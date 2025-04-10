{
  inputs = {
    flake-compat.url = "github:edolstra/flake-compat";
    flake-parts.url = "github:hercules-ci/flake-parts";
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
        flake-compat.follows = "flake-compat";
        nixpkgs.follows = "nixpkgs";
      };
    };
    hercules-ci-effects = {
      url = "github:hercules-ci/hercules-ci-effects";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };
    mnw.url = "github:Gerg-L/mnw";
    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs = {
        flake-compat.follows = "flake-compat";
        flake-parts.follows = "flake-parts";
        git-hooks.follows = "git-hooks";
        hercules-ci-effects.follows = "hercules-ci-effects";
        nixpkgs.follows = "nixpkgs";
      };
    };
    nixpkgs.url = "github:/NixOS/nixpkgs/nixpkgs-unstable";
  };
  outputs = {
    flake-parts,
    mnw,
    neovim-nightly,
    nixpkgs,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem = {system, ...}: let
        inherit (nixpkgs) lib;
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages.default = mnw.lib.wrap pkgs {
          inherit (neovim-nightly.packages.${system}) neovim;
          initLua =
            # lua
            ''
              require('config')
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
        };
      };
    };
}
