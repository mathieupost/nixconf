{ pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfree = true;
  # Enable experimental nix command and flakes
  nix.package = pkgs.unstable.nix;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '' + lib.optionalString (pkgs.system == "aarch64-darwin") ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';
  nix.configureBuildUsers = true;
  # nix.settings.auto-optimise-store = true;
  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";
    taps = [
    ];
    brews = [
      "mas"
      "cmake"
      "automake"
      "libtool"
      "pkg-config"
      "gcc"
      "fastlane"
      "cocoapods"
    ];
    casks = [
      "docker"
      "amethyst"
      "bluesnooze" # disable bluetooth on sleep.
      "choosy" # open specific links in specific apps.
      "google-chrome"
      "obsidian"
      "daisydisk"
      "raycast"
      "vlc"
      "transmission"
      "insomnia"
      "postman"
      "microsoft-teams"
      "visual-studio-code"
    ];
    masApps = {
      "Xcode" = 497799835;
      "1Password for Safari" = 1569813296;
      "AdGuard for Safari" = 1440147259;
      "Super Agent" = 1568262835;
      "Vimari" = 1480933944;
      "Barbee" = 1548711022;
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
  programs.fish.shellInit = ''for p in (string split " " $NIX_PROFILES); fish_add_path --prepend --move $p/bin; end'';

  security.pam.enableSudoTouchIdAuth = true;

  # Tailscale
  services.tailscale.enable = true;

  # Fonts
  fonts = {
    packages = with pkgs; [
      recursive
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
  };

  system.defaults.NSGlobalDomain = {
    AppleInterfaceStyle = "Dark";
    AppleKeyboardUIMode = 3;
    AppleEnableSwipeNavigateWithScrolls = true;
    AppleMetricUnits = 1;
    AppleMeasurementUnits = "Centimeters";
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
}
