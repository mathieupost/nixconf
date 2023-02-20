# Shell configuration
{ config, lib, pkgs, goBuildModule, ... }:

{
  home.packages = with pkgs; [
    any-nix-shell
    comma # run everything with "," without installing
    babelfish # convert POSIX to fish
    ttyd # shell in your browser
    nix-prefetch
    nix-prefetch-github
  ];

  programs.nix-index.enable = true;
  programs.nix-index.package = pkgs.unstable.nix-index;
  programs.bash.enable = true;
  programs.zsh.enable = true;
  programs.fish = {
    enable = true;
    shellAliases = {
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
      "......" = "cd ../../../../..";
      "zf" = "z --pipe=fzf";
      "glab" = "op plugin run -- glab";
    };
    functions = {
      darwin-switch = ''
        darwin-rebuild switch --flake ~/.config/nixpkgs
      '';
      fish_title = "prompt_pwd";
      fuzzy = ''
        set distance 2
        if test (count $argv) -gt 1
            set distance $argv[2]
        end
          set spacedistance 20
        if test (count $argv) -gt 2
            set spacedistance $argv[3]
        end
        set res (string replace -a -r '([^\s])' "\$1.{0,$distance}" $argv[1])
        set res (string replace -r "\.\{0,$distance\}\$" "" $res)
        set res (string replace " " ".{0,$spacedistance}" $res)
        echo $res
      '';
      rga-fzf = ''
        set RG_PREFIX 'rga --files-with-matches --sort=path'
        if test (count $argv) -gt 1
          set RG_PREFIX "$RG_PREFIX $argv[1..-2]"
        end
        set -l file $file
        set file (
          FZF_DEFAULT_COMMAND="$RG_PREFIX '$argv[-1]'" \
            fzf --sort --preview='test ! -z {} && \
                  rga --pretty \
                      --multiline \
                      --multiline-dotall \
                      --context 5 {q} {}' \
                --phony -q "$argv[-1]" \
                --bind "change:reload:$RG_PREFIX {q}" \
                --preview-window='70%:wrap'
        ) && \
          echo "opening $file" && \
          open "$file"
      '';
      sw = "darwin-rebuild switch --flake ~/.config/nixpkgs";
    };
    shellInit = ''
      any-nix-shell fish --info-right | source
      thefuck --alias | source
    '';
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 13;
    };
    keybindings = {
      "kitty_mod+f" = "launch --type=overlay --stdin-source=@screen_scrollback fzf --no-sort --no-mouse --exact -i";
    };
    settings = {
      term = "xterm-256color";
      macos_thicken_font = "0.25";
      macos_option_as_alt = "yes";
      scrollback_lines = 100000;
      close_on_child_death = "yes";
      hide_window_decorations = "yes";

      tab_bar_min_tabs = 1;
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
    };
    extraConfig = builtins.readFile (builtins.fetchurl {
      url = "https://raw.githubusercontent.com/GiuseppeCesarano/kitty-theme-OneDark/97781aa8ea2a4c74ecf711d5456e25509876d6e2/OneDark.conf";
      sha256 = "0ickbbk7j1ig66qp1rwxmpm8dd1kplijlhvdvk1s70xp8qr40a6z";
    });
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    SSL_CERT_FILE = "${pkgs.cacert.out}/etc/ssl/certs/ca-bundle.crt";

    # HACK prepend sessionPath to PATH
    OLD_PATH = "$PATH";
    PATH = "";

    # GO
    GOPATH = "$HOME/Dev";
    GOBIN = "$HOME/Dev/bin";
    GOPRIVATE = "lab.weave.nl";
  };
  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/Dev/bin"
    "$HOME/Dev/sdk/flutter/.pub-cache/bin"
    "$HOME/Dev/sdk/flutter/bin"
    "$HOME/.emacs.d/bin"
    "$OLD_PATH"
  ];

  programs.go = {
    goPath = "$GOPATH";
    goBin = "$GOBIN";
    goPrivate = "$GOPRIVATE";
  };

  programs.starship = {
    enable = true;
    settings = {
      cmd_duration.min_time = 500;
      command_timeout = 1000;
    };
  };

  programs.pazi.enable = true;
  programs.dircolors.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    stdlib = ''
      layout_poetry() {
          PYPROJECT_TOML="''${PYPROJECT_TOML:-pyproject.toml}"
          if [[ ! -f "$PYPROJECT_TOML" ]]; then
              log_status "No pyproject.toml found. Executing \`poetry init\` to create a \`$PYPROJECT_TOML\` first."
              poetry init
          fi

          if [[ -d ".venv" ]]; then
              VIRTUAL_ENV="$(pwd)/.venv"
          else
              VIRTUAL_ENV=$(poetry env info --path 2>/dev/null ; true)
          fi

          if [[ -z $VIRTUAL_ENV || ! -d $VIRTUAL_ENV ]]; then
              log_status "No virtual environment exists. Executing \`poetry install\` to create one."    
              poetry install
              VIRTUAL_ENV=$(poetry env info --path)
          fi

          PATH_add "$VIRTUAL_ENV/bin"
          export POETRY_ACTIVE=1
          export VIRTUAL_ENV
      }
    '';
  };
  programs.fzf = {
    enable = true;
  };
}
# vim: sw=2 sts=2 ts=2 fdm=indent expandtab
