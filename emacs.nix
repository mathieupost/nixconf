# Emacs configuration
{ config, lib, pkgs, ... }:

{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs28NativeComp;
    extraPackages = (epkgs: [ epkgs.vterm ]);
  };

  home.packages = with pkgs; [
    texlive.combined.scheme-full
    graphviz
    inkscape
    imagemagick
    plantuml
    (aspellWithDicts (dicts: with dicts; [ nl en en-computers en-science ]))
  ];
}
# vim: sw=2 sts=2 ts=2 fdm=indent noexpandtab
