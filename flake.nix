{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    gomod2nix.url = "github:tweag/gomod2nix";
    yamlfmt = {
      url = "github:google/yamlfmt/v0.5.0";
      flake = false;
    };
  };

  inputs = {
    # dev
    devshell.url = "github:numtide/devshell";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = {
    self,
    flake-utils,
    ...
  } @ inputs: (
    flake-utils.lib.eachDefaultSystem
    (system: let
      inherit (pkgs) lib;
      pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [
          inputs.gomod2nix.overlays.default
          inputs.devshell.overlay
        ];
      };
    in {
      packages.yamlfmt = pkgs.buildGoApplication {
        pname = "yamlfmt";
        version = "0.5.0";
        src = inputs.yamlfmt;
        modules = ./gomod2nix.toml;
      };

      checks = {
        yamlfmt = self.packages.${system}.yamlfmt;
      };

      devShells.default = pkgs.devshell.mkShell {
        commands = with pkgs; [
          {
            name = "generate-gomod2nix";
            command = "gomod2nix --dir ${inputs.yamlfmt} --outdir ./";
          }
        ];
        packages = with pkgs; [
          alejandra
          gomod2nix
        ];
      };
    })
  );
}
