{ ocamlPackages, packages, pkgs }:

with ocamlPackages;

pkgs.mkShell {
  inputsFrom = with packages; [ {{ project_slug }} ];
  buildInputs = [
    ocaml
    dune
    ocaml-lsp
    ocamlformat
    merlin
    utop
    odoc
    pkgs.pkg-config
    pkgs.openssl
  ];
}
