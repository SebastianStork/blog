{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    treefmt = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    linkita = {
      url = "github:SebastianStork/kita";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      treefmt,
      linkita,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = [ pkgs.zola ];

        shellHook = ''
          mkdir -p themes
          ln -snf "${linkita}" themes/kita
        '';
      };

      formatter.${system} =
        (treefmt.lib.evalModule pkgs {
          projectRootFile = "flake.nix";
          programs = {
            nixfmt.enable = true;
            prettier.enable = true;
            just.enable = true;
          };
        }).config.build.wrapper;
    };
}
