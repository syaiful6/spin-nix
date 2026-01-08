{
  mkShell,
  treefmt,
  ocamlPackages,
  systemfd,
  watchexec,
}:
mkShell {
  inputsFrom = with ocamlPackages; [
    {{ project_slug }}
  ];
  buildInputs =
    (with ocamlPackages; [
      ocaml-lsp
      ocamlformat
      utop
    ])
    ++ [
      treefmt
      systemfd
      watchexec
    ];
}
