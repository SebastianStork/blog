{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    linkita = {
      url = "git+https://codeberg.org/salif/linkita.git";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
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
          ln -snf "${linkita}" themes/linkita
        '';
      };

      formatter.${system} = pkgs.nixfmt-tree;
    };
}
