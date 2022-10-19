{
  description = "Nix Darwin configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:NixOS/nixpkgs/22.05";
    # unstable.url = "github:NixOS/nixpkgs";

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    homeManager = {
      url = "github:nix-community/home-manager/release-22.05";
      # url = "path:/Users/mathieu/Dev/src/m9t.dev/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, darwin, nixpkgs, homeManager }: {
    darwinConfigurations = {
      MacBook-Pro = darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        inputs = { inherit darwin nixpkgs homeManager; };
        modules = [
          ./configuration.nix
          homeManager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.mathieu = { pkgs, ... }: {
              nix.package = pkgs.nix;

              imports = [
                ./home.nix
                ./darwin.nix
              ];
            };
          }
        ];
      };
      Mathieus-HackBook-Pro = darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        inputs = { inherit darwin nixpkgs homeManager; };
        modules = [
          ./configuration.nix
          homeManager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.mathieu = { pkgs, ... }: {
              nix.package = pkgs.nix;

              imports = [
                ./home.nix
                ./darwin.nix
              ];
            };
          }
        ];
      };
    };
  };
}
#           pkgs = import nixpkgs {
#             inherit system;
#             config = {
#               allowUnfree = true;
#               allowBroken = true;
#             };
#             overlays = [
#               (final: prev: {
#                 unstable = import unstable {
#                   inherit system;
#                   config = prev.pkgs.config;
#                 };
#               })
#             ];
#           };
# vim: sw=2 sts=2 ts=2 fdm=indent expandtab
