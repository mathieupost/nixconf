{
  description = "Nix Darwin configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/22.11";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

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

    neovim.url = "github:nix-community/neovim-nightly-overlay";
    neovim.inputs.nixpkgs.follows = "unstable";
  };

  outputs = inputs@{ self, darwin, nixpkgs, unstable, homeManager, nixIndexDatabase, neovim }:
    let mySystem = darwin.lib.darwinSystem rec {
      system = "x86_64-darwin";
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
            neovim-nightly-overlay = neovim.overlay;
          in
          {
            nixpkgs.overlays = [
              overlay-unstable
              neovim-nightly-overlay
            ];
          }
        )
        # Enable searching the index for missing binaries
        nixIndexDatabase.nixosModules.nix-index
        homeManager.darwinModules.home-manager
        {
          nix.nixPath = [ "nixpkgs=${nixpkgs}" "nixpkgs-unstable=${unstable}" ];
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          users.users.mathieu = {
            name = "mathieu";
            home = "/Users/mathieu";
          };
          home-manager.users.mathieu = { config, pkgs, lib, ... }: {
            home.stateVersion = "22.11";
            imports = [
              ./home.nix
              ./darwin.nix
            ];
          };
        }
        ./configuration.nix
      ];
    };
    in
    {
      darwinConfigurations = {
        Mathieus-MBP = mySystem;
        MacBook-Pro = mySystem;
        Mathieus-HackBook-Pro = mySystem;
        Mathieus-MacBook-Pro = mySystem;
        MathieukBookPro = mySystem;
      };
    };
}
# vim: sw=2 sts=2 ts=2 fdm=indent expandtab
