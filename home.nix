{ config, pkgs, lib, ... }:

let
  pritunl-client = pkgs.callPackage ./pritunl-client.nix { };
in
{
  imports = [
    ./git.nix
    ./shell.nix
    ./terminal.nix
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

    # unstable._1password # cli # copied to /usr/local/bin/op in configuration.nix
    # unstable._1password-gui # does not work.
    # nicotine-plus # Soulseek client

    # cli tools
    pkgconf
    coreutils-prefixed # gnu coreutils
    gnused
    ripgrep # super fast grep
    ugrep # grep in pdf, zip, etc.
    fd # find replacement written in rust
    jq # parse json in the terminal
    unstable.flyctl # fly.io cli (heroku like service)
    k9s
    postgresql
    pgcli

    # editor
    unstable.neovim
    nodejs
    cargo
  ];
}
# vim: sw=2 sts=2 ts=2 fdm=indent expandtab
