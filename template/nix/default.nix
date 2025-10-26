{ lib, stdenv, ocamlPackages, nix-filter, doCheck ? true, pkgs }:

with ocamlPackages;

let
  genSrc = { dirs, files }:
    let
      root = ./..;

      mkDirMatcher = dirs: args:
        let
          rootPath = toString args.root;
          getParents = path:
            let
              parts = lib.filter (p: p != "") (lib.splitString "/" path);
              numParts = builtins.length parts;
              mkPaths = n:
                if n == 0 then []
                else [ (lib.concatStringsSep "/" (lib.take n parts)) ] ++ (mkPaths (n - 1));
            in
            mkPaths (numParts - 1);

          fullDirs = dirs;
          parentDirs = lib.unique (lib.concatMap getParents dirs);

        in
        path: type:
          let
            pathStr = toString path;
            relPath = lib.removePrefix (rootPath + "/") pathStr;
          in
          builtins.any (dir:
            relPath == dir || lib.hasPrefix (dir + "/") relPath
          ) fullDirs
          || (type == "directory" && builtins.elem relPath parentDirs);
    in
    nix-filter.filter {
      inherit root;
      include = [ "dune-project" ] ++ files ++ [ (mkDirMatcher dirs) ];
    };
  buildProject = args: buildDunePackage ({
    version = "0.1.0";
    doCheck = doCheck;
    duneVersion = "3";
    nativeBuildInputs = [ pkgs.pkg-config ];
    buildInputs = [ pkgs.openssl ];
    checkInputs = [ alcotest ];
    PKG_CONFIG_PATH = pkgs.lib.makeSearchPath "lib/pkgconfig" [
      pkgs.openssl
    ];
  } // args);
  in

  {
    # define your packages here, they can depends each others
    {{ project_slug }} = buildProject {
      pname = "{{ project_slug }}";
      src = genSrc {
        dirs = [ "src" ];
        files = [ "{{ project_slug }}.opam" ];
      };
      # add your OCaml dependencies here
      propagatedBuildInputs = [];
    };
  }
