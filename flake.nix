{
  description = "Neovim 0.12 flake with support for my personal configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
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
              # Conditionally include Linux clipboard tools
              ++ lib.optionals stdenv.isLinux [
                xclip
                wl-clipboard
              ]
            ))
          ];
        };
      in
      {
        # Define the default package for the current system
        packages.default = neovim-default;
      }
    );
}
