{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    treefmt = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    kita = {
      url = "github:SebastianStork/kita";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      treefmt,
      kita,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        name = "blog";
        src = ./.;
        nativeBuildInputs = [ pkgs.zola ];
        buildPhase = ''
          cp -r $src/* .
          mkdir -p themes/kita
          cp -r ${kita}/* themes/kita/
          zola build --output-dir $out
        '';
        doCheck = false;
      };

      devShells.${system}.default = pkgs.mkShell {
        packages = [ pkgs.zola ];
        shellHook = ''
          mkdir -p themes
          ln -snf "${kita}" themes/kita
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
