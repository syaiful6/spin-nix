{
  system ? builtins.currentSystem,
  doCheck ? true,
}:
let
  flakeLock = builtins.fromJSON (builtins.readFile ./flake.lock);
  fetchGithub =
    flakeInput:
    builtins.fetchTarball {
      url = "https://github.com/${flakeLock.nodes.${flakeInput}.locked.owner}/${
        flakeLock.nodes.${flakeInput}.locked.repo
      }/archive/${flakeLock.nodes.${flakeInput}.locked.rev}.tar.gz";
      sha256 = flakeLock.nodes.${flakeInput}.locked.narHash;
    };
  nixpkgsSrc = fetchGithub "nixpkgs";
  treefmtSrc = fetchGithub "treefmt-nix";

  pkgs = import nixpkgsSrc {
    inherit system;
    overlays = [
      (import ./nix/overlays)
      (_final: prev: {
        treefmt-nix = import treefmtSrc;
        {{ project_slug }} = prev.{{ project_slug }}.overrideScope (
          _final': _prev': {
            inherit doCheck;
          }
        );
      })
      (import ./nix/overlays/development.nix)
    ];
  };

  ocamlPackageSets = [
    "ocamlPackages"
    "ocamlPackages_5_4"
    "ocamlPackages_5_3"
    "ocamlPackages_5_2"
  ];
  packageNames = [
    "{{ project_slug }}"
  ];
  outputs = pkgs.lib.genAttrs ocamlPackageSets (
    ocamlPackages: pkgs.lib.genAttrs packageNames (package: pkgs.ocaml-ng.${ocamlPackages}.${package})
  );
in
outputs
// {
  inherit (pkgs.ocamlPackages)
    {{ project_slug }}
    ;
  inherit (pkgs.{{ project_slug }})
    dev-shell
    ;
  checks.formatting = pkgs.{{ project_slug }}.checks.formatting;
}
