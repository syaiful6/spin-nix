OCaml + Nix = reproducible builds and strong types. What could go wrong?

## Usage

This template is meant to be used with [spin](https://github.com/tmattio/spin):

```bash
spin new https://github.com/syaiful6/spin-nix my-nix-ocaml-project
```

Spin will ask you some questions, scaffold your project, and boom—you're ready to code!

## What's in the box?

- **Nix flake** with OCaml 5.3
- **Dune** build system
- **direnv** support (.envrc) for automatic environment loading
- **Alcotest** for testing (test or it didn't happen)
- Basic library + test structure
