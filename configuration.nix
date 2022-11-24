{ pkgs, ... }:

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

  # Enable searching the index for missing binaries
  programs.nix-index.enable = true;
  programs.nix-index.package = pkgs.unstable.nix-index;

  homebrew = {
    enable = true;
    brews = [
      "mas"
      "languagetool"
    ];
    masApps = {
      "Xcode" = 497799835;
      "1Password for Safari" = 1569813296;
      "AdGuard for Safari" = 1440147259;
      "Vimari" = 1480933944;
      "Glance" = 1564688210;
      "Slack" = 803453959;
      "Save to Matter" = 1548677272;
    };
  };

  environment.shells = [ pkgs.fish pkgs.zsh pkgs.bash ];
  programs.bash.enable = true;
  programs.zsh.enable = true;
  programs.fish.enable = true;

  # Tailscale
  environment.systemPackages = with pkgs; [ tailscale ];
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
