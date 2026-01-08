{
  description = "{{ project_name }} - Nix Flake Template";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-25.11";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.flake = false;
  };

  outputs =
    {
      self,
      nixpkgs,
      treefmt-nix,
    }:
    let
      allSystems = nixpkgs.lib.systems.flakeExposed;
      withPkgs =
        pkgsCallback:
        nixpkgs.lib.genAttrs allSystems (
          system:
          let
            pkgs = import nixpkgs {
              inherit system;
              overlays = [
                (import ./nix/overlays)
                (_final: _prev: {
                  treefmt-nix = import treefmt-nix;
                })
                (import ./nix/overlays/development.nix)
              ];
            };
          in
          pkgsCallback { inherit pkgs system; }
        );

    in
    {
      packages = withPkgs (
        { pkgs, system }:
        {
          default = self.packages.${system}.{{ project_slug }};
          inherit (pkgs.ocamlPackages)
            {{ project_slug }}
            ;
        }
      );

      devShells = withPkgs (
        { pkgs, ... }:
        {
          default = pkgs.{{ project_slug }}.dev-shell;
        }
      );

      overlays.default = import ./nix/overlays;

      formatter = withPkgs ({ pkgs, ... }: pkgs.{{ project_slug }}.treefmt);

      checks = withPkgs (
        { pkgs, ... }:
        {
          formatting = pkgs.{{ project_slug }}.checks.formatting;
        }
      );
    };
}
