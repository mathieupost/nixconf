{ config, lib, pkgs, ... }:

{
  imports = [
    # Enable macOS Applications/ support
    (builtins.fetchurl {
      url = "https://raw.githubusercontent.com/Atemu/home-manager/e6d905336181ed8f98d48a1f6c9965b77f18e304/modules/targets/darwin.nix";
      sha256 = "0lsa8ncwvv5qzar2sa8mxblhg6wcq5y6h9ny7kgmsby4wzaryz67";
    })
  ];

  darwin.installApps = true;
  darwin.fullCopies = true;
  targets.darwin = {
    defaults = {
      com.apple.Safari.AutoFillPasswords = false;
      com.apple.Safari.AutoFillCreditCardData = false;
      com.apple.Safari.IncludeDevelopMenu = true;
      com.apple.menuextra.battery.ShowPercent = true;
    };
    search = "Ecosia";
  };

  home.packages = with pkgs; [
    goku # karabiner-elements configuration utility
    joker # goku dependency (clojure interpreter and linter)
  ];
}
# vim: sw=2 sts=2 ts=2 fdm=indent expandtab
