{ config, lib, pkgs, ... }:

{
  targets.darwin = {
    defaults = {
      "com.apple.Safari" = {
        AutoFillPasswords = false;
        AutoFillCreditCardData = true;
        IncludeDevelopMenu = true;
        ShowOverlayStatusBar = true;
      };
    };
    search = "Ecosia";
  };

  home.packages = with pkgs; [
    goku # karabiner-elements configuration utility
    joker # goku dependency (clojure interpreter and linter)
  ];
}
# vim: sw=2 sts=2 ts=2 fdm=indent expandtab
