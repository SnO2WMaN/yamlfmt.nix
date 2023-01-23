{
  pkgs ? (
    let
      inherit (builtins) fetchTree fromJSON readFile;
      inherit ((fromJSON (readFile ./flake.lock)).nodes) nixpkgs gomod2nix;
    in
      import (fetchTree nixpkgs.locked) {
        overlays = [(import "${fetchTree gomod2nix.locked}/overlay.nix")];
      }
  ),
  src ? (
    let
      inherit (builtins) fetchTree fromJSON readFile;
      inherit ((fromJSON (readFile ./flake.lock)).nodes) yamlfmt;
    in
      pkgs.fetchFromGitHub {
        inherit (yamlfmt) owner repo rev narHash;
      }
  ),
}:
pkgs.buildGoApplication {
  inherit src;
  pname = "yamlfmt";
  version = "0.7.1";
  modules = ./gomod2nix.toml;
}
