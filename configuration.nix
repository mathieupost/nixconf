{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  # Enable experimental nix command and flakes
  # nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  nix.configureBuildUsers = true;
  nix.settings.auto-optimise-store = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;
  programs.nix-index.enable = true;

  homebrew = {
    enable = true;
    brews = [
      "mas"
      "languagetool"
    ];
    masApps = {
      "Xcode" = 497799835;
      "1Password for Safari" = 1569813296;
      # "1Password 7" = 1333542190; TODO update to 1Password 8 when available.
      "AdGuard for Safari" = 1440147259;
      "Vimari" = 1480933944;
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

  environment.systemPackages = with pkgs; [ tailscale ];

  # Tailscale
  environment.launchDaemons."com.tailscale.tailscaled.plist" = {
    text = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>

        <key>Label</key>
        <string>com.tailscale.tailscaled</string>

        <key>ProgramArguments</key>
        <array>
          <string>${pkgs.tailscale}/bin/tailscaled</string>
        </array>

        <key>RunAtLoad</key>
        <true/>

      </dict>
      </plist>
    '';
  };

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
