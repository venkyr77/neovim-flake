{
  inputs = {
    blink-cmp = {
      url = "github:Saghen/blink.cmp";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };
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
    blink-cmp,
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
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        formatter = pkgs.writeShellApplication {
          name = "format";
          runtimeInputs = builtins.attrValues {
            inherit (pkgs) alejandra deadnix fd statix stylua;
          };
          text = ''
            fd "$@" -t f -e nix -x statix fix -- '{}'
            fd "$@" -t f -e nix -X deadnix -e -- '{}'
            fd "$@" -t f -e nix -X alejandra '{}'
            fd "$@" -t f -e lua -X stylua --indent-type Spaces --indent-width 2 '{}'
          '';
        };

        packages.default = mnw.lib.wrap pkgs {
          inherit (neovim-nightly.packages.${system}) neovim;
          plugins = [
            {
              pname = "blink.cmp";
              src = blink-cmp.packages.${system}.blink-cmp;
              optional = true;
            }
          ];
          imports = [./config.nix];
        };
      };
    };
}
