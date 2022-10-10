# yamlfmt.nix, nix flake for [yamlfmt](https://github.com/google/yamlfmt)

## Usage

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    devshell.url = "github:numtide/devshell";
    yamlfmt.url = "github:SnO2WMaN/yamlfmt.nix"; # 1
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = with inputs; [
            devshell.overlay
            (final: prev: {
              yamlfmt = yamlfmt.packages.${system}.yamlfmt;
            }) # 2
          ];
        };
      in {
        devShells.default = pkgs.devshell.mkShell {
          packages = with pkgs; [ 
            yamlfmt #3
          ];
        };
      }
    );
}
```

1. Import this flake.
2. Create an overlay (because this flake depends on [gomod2nix](https://github.com/nix-community/gomod2nix), so can't provide overlay.)
3. Add `pkgs.yamlfmt` for your shell.
 