# Emacs configuration
{ config, lib, pkgs, ... }:

{
  programs.emacs = {
    enable = true;
    package = pkgs.unstable.emacs29-macport;
    extraPackages = epkgs: with epkgs; [ vterm zmq ];
  };

  home.packages = with pkgs; [
    texlive.combined.scheme-full
    graphviz
    inkscape
    pdf2svg # for inlining pdfs in org-mode
    imagemagick
    plantuml
    (aspellWithDicts (dicts: with dicts; [ nl en en-computers en-science ]))
    languagetool
  ];
}
# vim: sw=2 sts=2 ts=2 fdm=indent expandtab
