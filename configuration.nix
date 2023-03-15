{ pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfree = true;
  # Enable experimental nix command and flakes
  nix.package = pkgs.unstable.nix;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  nix.configureBuildUsers = true;
  # nix.settings.auto-optimise-store = true;
  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  homebrew = {
    enable = true;
    brews = [
      "mas"
    ];
    casks = [
      "raycast"
    ];
    masApps = {
      "Xcode" = 497799835;
      "1Password for Safari" = 1569813296;
      "AdGuard for Safari" = 1440147259;
      "Super Agent" = 1568262835;
      "Vimari" = 1480933944;
      "Slack" = 803453959;
      "Save to Reader" = 1640236961;
    };
  };

  system.activationScripts.postUserActivation.text = ''
    sudo cp -f ${pkgs.unstable._1password}/bin/op /usr/local/bin/op
  '';

  environment.shells = [ pkgs.fish pkgs.zsh pkgs.bash ];
  programs.bash.enable = true;
  programs.zsh.enable = true;
  programs.fish.enable = true;
  programs.fish.loginShellInit = ''for p in (string split " " $NIX_PROFILES); fish_add_path --prepend --move $p/bin; end'';

  security.pam.enableSudoTouchIdAuth = true;

  # Tailscale
  services.tailscale.enable = true;

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
