{ pkgs, lib, ... }: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  users.users.mathieu = {
    name = "mathieu";
    home = "/Users/mathieu";
    shell = pkgs.zsh;
  };
  home-manager.users.mathieu = { config, pkgs, lib, ... }: {
    home.stateVersion = "24.05";
    imports = [
      ./home.nix
      ./darwin.nix
    ];
  };
}
