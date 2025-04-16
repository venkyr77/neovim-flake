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
      ${builtins.readFile ./config/options.lua}
      ${builtins.readFile ./config/editor/colorscheme.lua}
      ${builtins.readFile ./config/editor/which-key.lua}
      ${builtins.readFile ./config/editor/neo-tree.lua}
      ${builtins.readFile ./config/editor/snacks.lua}
      ${builtins.readFile ./config/editor/auto-save.lua}
      ${builtins.readFile ./config/editor/bufferline.lua}
      ${builtins.readFile ./config/editor/gitsigns.lua}
      ${builtins.readFile ./config/editor/guess-indent.lua}
      ${builtins.readFile ./config/editor/lualine.lua}
      ${builtins.readFile ./config/editor/noice.lua}
      ${builtins.readFile ./config/editor/nvim-autopairs.lua}
      ${builtins.readFile ./config/editor/smartyank.lua}
      ${builtins.readFile ./config/editor/todo-comments.lua}
      ${builtins.readFile ./config/editor/treesitter.lua}
      ${builtins.readFile ./config/completion/init.lua}
      ${builtins.readFile ./config/format/init.lua}
      ${import ./config/lsp {inherit pkgs;}}
      ${builtins.readFile ./config/lint/init.lua}
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
            "bufferline.nvim"
            "catppuccin.nvim"
            "conform.nvim"
            "friendly-snippets"
            "gitsigns.nvim"
            "guess-indent.nvim"
            "lualine.nvim"
            "LuaSnip"
            "neo-tree.nvim"
            "nvim-autopairs"
            "nvim-lint"
            "nvim-lspconfig"
            "noice.nvim"
            "smartyank.nvim"
            "snacks.nvim"
            "todo-comments.nvim"
            "which-key.nvim"
          ];
        }
      )
    ) (import ./npins/default.nix);
}
