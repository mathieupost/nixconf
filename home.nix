{ config, pkgs, lib, ... }:

{
  imports = [
    ./git.nix
    ./shell.nix
    ./ssh.nix
  ];

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
    # gpg.enable = true;
    java.enable = true;
  };

  home.packages = with pkgs; [
    nix # manage nix with Home Manager. DON'T REMOVE
    rnix-lsp

    docker
    # nicotine-plus # Soulseek client

    # cli tools
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
    # timetrap # tui time tracker

    flyctl # fly.io cli (heroku like service)

    ripgrep-all # ripgrep, but also search in PDFs, E-Books, Office documents, zip, tar.gz, and more
    graphicsmagick # for pdfs

    # editor
    neovim
    nodePackages.neovim
    tree-sitter
    efm-langserver # general purpose lsp

    # Emacs/LaTeX
    emacs
    texlive.combined.scheme-full
    graphviz
    inkscape
    imagemagick
    plantuml
    (aspellWithDicts (dicts: with dicts; [ nl en en-computers en-science ]))

    pgcli # postgres cli
    (postgresql_13.withPackages (p: [ p.postgis ]))

    # golang
    go
    gopls # lsp
    gotools # goimports etc.
    gofumpt # formatter like gofmt
    # golangci-lint # code linter
    # cobra # cli project generator
    # go-mockery
    protoc-gen-go

    # web lsp's
    nodePackages.vscode-langservers-extracted

    # javascript, json, node
    nodejs
    nodePackages.prettier # format json

    # lua
    lua
    sumneko-lua-language-server # lsp

    # python
    (python3Full.withPackages (ps:
      with ps;
      with python3Packages; [
        pynvim # python neovim support
        # scientific libs
        numpy
        pandas
        matplotlib
      ]))
    python39Packages.pip
    pipenv # create environments per project
    nodePackages.pyright # lsp
    python39Packages.pyflakes # check errors/imports
    python39Packages.pylint
    python39Packages.isort # sort imports
    black # python code formatter

    # rust
    cargo

    clojure

    kafkacat
  ];
}
# vim: sw=2 sts=2 ts=2 fdm=indent noexpandtab
