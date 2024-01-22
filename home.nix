{ config, pkgs, lib, ... }:

let
  pritunl-client = pkgs.callPackage ./pritunl-client.nix { };
in
{
  imports = [
    ./git.nix
    ./shell.nix
    ./ssh.nix
    ./emacs.nix
  ];

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
    java.enable = true;
  };

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    unstable.ollama

    (unstable.python3.withPackages (ps: with ps; [
      jupyterlab
      numpy
      pandas
      matplotlib
      seaborn
    ]))

    # unstable._1password # cli # copied to /usr/local/bin/op in configuration.nix
    # unstable._1password-gui # does not work.
    # nicotine-plus # Soulseek client
    unstable.jetbrains.pycharm-professional
    unstable.jetbrains.goland
    gopls
    delve
    rnix-lsp
    tree-sitter

    # cli tools
    pkgconf
    coreutils # gnu coreutils
    gnused
    ripgrep # super fast grep
    ugrep # grep in pdf, zip, etc.
    fd # find replacement written in rust
    jq # parse json in the terminal
    unstable.flyctl # fly.io cli (heroku like service)
    glab
    k9s
    postgresql
    pgcli

    graphviz

    # editor
    unstable.neovim
    nodejs
    cargo
  ];
}
# vim: sw=2 sts=2 ts=2 fdm=indent expandtab
