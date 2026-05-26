{
  description = "Neovim 0.12 flake with support for my personal configuration";

  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          lib = pkgs.lib;

          neovim-default = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped {
            plugins = [ ];
            luaRcContent = "";
            wrapRc = false;
            withPython3 = false;
            withRuby = false;
            withNodeJs = false;
            viAlias = false;
            vimAlias = false;
            wrapperArgs = [
              "--suffix"
              "PATH"
              ":"
              (lib.makeBinPath (
                with pkgs;
                [
                  # clipboard
                  xclip
                  wl-clipboard
                  # blink.cmp
                  curl
                  # Treesitter
                  gcc
                  tree-sitter
                  # plugins requiring node (copilot, etc.)
                  nodejs_24
                  # Snacks
                  ripgrep
                  fd
                  lazygit
                  git
                  # optional tools
                  deno # peek.nvim
                  gh # github autocompletion + octo.nvim
                ]
              ))
            ];
          };
        in
        {
          default = neovim-default;
        }
      );
    };
}
