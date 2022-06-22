{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  # Enable experimental nix command and flakes
  # nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
  '';
  users.nix.configureBuildUsers = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;
  programs.nix-index.enable = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  homebrew = {
    enable = true;
    brews = [
      "mas"
      "languagetool"
    ];
    masApps = {
      "1Password 7" = 1333542190;
      "Xcode" = 497799835;
      "AdGuard for Safari" = 1440147259;
    };
  };

  environment.shells = [ pkgs.fish pkgs.zsh ];
  programs.zsh.enable = true;
  programs.fish = {
    enable = true;
    useBabelfish = true;
    babelfishPackage = pkgs.babelfish;
  };

  # checkout lorri for automatic direnv shell.nix integration

  # services.postgresql.enable = true;
  # services.postgresql.extraPlugins = [ /* configure postgis */ ]

  # Fonts
  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      recursive
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
  };

  system.defaults.NSGlobalDomain = {
    AppleInterfaceStyle = "Dark";
    AppleKeyboardUIMode = 3;
    AppleMeasurementUnits = "Centimeters";
    AppleMetricUnits = 1;
    AppleTemperatureUnit = "Celsius";
    ApplePressAndHoldEnabled = false;
    NSNavPanelExpandedStateForSaveMode = true;
    NSNavPanelExpandedStateForSaveMode2 = true;
  };

  system.defaults.dock = {
    autohide = true;
    mru-spaces = false;
    wvous-bl-corner = 4; # Desktop
    wvous-br-corner = 14; # Quick Note
  };

  system.defaults.finder = {
    AppleShowAllExtensions = true;
    FXDefaultSearchScope = "SCcf"; # Current Folder
    FXEnableExtensionChangeWarning = false;
    FXPreferredViewStyle = "clmv"; # Column View
    ShowPathbar = true;
    ShowStatusBar = true;
  };

  system.defaults.loginwindow.GuestEnabled = false;

  system.keyboard.enableKeyMapping = true;
  system.keyboard.nonUS.remapTilde = true;
}
