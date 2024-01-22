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
    # VPN
    pritunl-client

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
    autoconf
    curl
    ripgrep # super fast grep
    ugrep # ultra fast grep
    fd # find replacement written in rust
    bat # cat replacement written in rust
    jq # parse json in the terminal
    yq-go # parse yaml in the terminal
    htop # see all the processes
    ctags # create index of objects in source files
    cmake # make all
    flyctl # fly.io cli (heroku like service)

    ripgrep-all # ripgrep, but also search in PDFs, E-Books, Office documents, zip, tar.gz, and more
    graphicsmagick # for pdfs

    # editor
    unstable.neovim
    nodejs
    cargo
  ];
}
# vim: sw=2 sts=2 ts=2 fdm=indent expandtab
