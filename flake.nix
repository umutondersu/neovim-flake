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
                  xclip
                  xsel
                  wl-clipboard
                  tree-sitter
                  nodejs_24 # copilot.lua + build commands for some plugins
                  deno # peek.nvim
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
