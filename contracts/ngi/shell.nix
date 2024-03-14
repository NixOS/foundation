let
  pkgs = import (fetchTarball https://github.com/NixOS/nixpkgs/tarball/nixos-23.11) { };
  pdf = number: contract:
    let
      script = pkgs.writeShellApplication {
        name = "pdf";
        # put the file in this directory
        text = "install -m u=rw ${contract} ${toString ./.}/${number}.pdf";
      };
    in
    pkgs.mkShellNoCC {
      packages = [ script ];
    };
in
builtins.mapAttrs pdf (import ./contracts.nix)
