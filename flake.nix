{
  description = "Nix Darwin configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-22.11-darwin";
    unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    homeManager = {
      url = "github:nix-community/home-manager/release-22.11";
      # url = "path:/Users/mathieu/Dev/src/m9t.dev/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixIndexDatabase = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, darwin, nixpkgs, unstable, homeManager, nixIndexDatabase }:
    let mySystem = darwin.lib.darwinSystem rec {
      system = "aarch64-darwin";
      inputs = { inherit darwin nixpkgs homeManager; };
      modules = [
        ({ config, pkgs, ... }:
          let
            overlay-unstable = final: prev: {
              unstable = import unstable {
                inherit system;
                config = prev.pkgs.config;
              };
            };
          in
          {
            nixpkgs.overlays = [
              overlay-unstable
            ];
          }
        )
        # Enable searching the index for missing binaries
        nixIndexDatabase.nixosModules.nix-index
        {
          nix.nixPath = [
            { nixpkgs = "${nixpkgs}"; }
            { nixpkgs-unstable = "${unstable}"; }
          ];
        }
        homeManager.darwinModules.home-manager
        ./users.nix
        ./configuration.nix
      ];
    };
    in
    {
      darwinConfigurations = {
        Mathieus-M2-Pro = mySystem;
      };
    };
}
# vim: sw=2 sts=2 ts=2 fdm=indent expandtab
