{
  description = "Neovim 0.12 flake with treesitter-cli + clipboard support";

  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
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
            ]
          ))
        ];
      };
    in
    {
      packages.${system}.default = neovim-default;
    };
}
