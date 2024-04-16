{ config, pkgs, lib, inputs, ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      unstable = import inputs.unstable {
        system = pkgs.system;
        config = prev.pkgs.config;
      };
    })
    (final: prev: rec {
      intel = import inputs.nixpkgs {
        system = "x86_64-darwin";
        config = prev.pkgs.config;
      };
    })
  ];
  nix.nixPath = [
    { nixpkgs = "${inputs.nixpkgs}"; }
    { nixpkgs-unstable = "${inputs.unstable}"; }
  ];
}
