{
  description = "Nix Darwin configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.05-darwin";
    unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    homeManager = {
      url = "github:nix-community/home-manager/release-24.05";
      # url = "path:/Users/mathieu/Dev/src/m9t.dev/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixIndexDatabase = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, darwin, nixpkgs, unstable, homeManager, nixIndexDatabase }@inputs:
    let mySystem = darwin.lib.darwinSystem rec {
      inherit inputs;
      system = "aarch64-darwin";
      modules = [
        ./overlays.nix
        # Enable searching the index for missing binaries
        # nixIndexDatabase.nixosModules.nix-index
        homeManager.darwinModules.home-manager
        ./users.nix
        ./configuration.nix
      ];
    };
    in
    {
      darwinConfigurations = {
        Mathieus-M2-Pro = mySystem;
        Mathieus-MacBook-Pro-2 = mySystem;
        Mathieus-MacBook-M2-Pro = mySystem;
      };
    };
}
# vim: sw=2 sts=2 ts=2 fdm=indent expandtab
