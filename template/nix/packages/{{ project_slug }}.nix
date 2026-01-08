{
  buildDunePackage,
  lib,
  alcotest,
  doCheck ? true,
}:

buildDunePackage {
  pname = "{{ project_slug }}";
  version = "0.1.0";

  src =
    let
      fs = lib.fileset;
    in
    fs.toSource {
      root = ../..;
      fileset = fs.unions [
        ../../src
        ../../dune-project
        # uncomment this after dune generates the file
        #../../{{ project_snake }}.opam
      ];
    };

  # add your dependencies here
  propagateBuildInputs = [ ];

  inherit doCheck;

  checkInputs = [ alcotest ];
}
