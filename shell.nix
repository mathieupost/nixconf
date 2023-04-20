# Shell configuration
{ config, lib, pkgs, goBuildModule, ... }:

{
  home.packages = with pkgs; [
    any-nix-shell
    comma # run everything with "," without installing
    thefuck
    babelfish # convert POSIX to fish
    ttyd # shell in your browser
  ];

  programs.bash.enable = true;
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    autocd = true;
  };
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
      darwin-switch = "darwin-rebuild switch --flake ~/.config/nixconf";
      fish_title = "prompt_pwd"; # set terminal window title
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
      "shift+enter" = "send_text all \\x1b[13;2u";
      "ctrl+enter" = "send_text all \\x1b[13;5u";
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
  };
  home.sessionPath = [
    "/opt/homebrew/bin"
  ];

  programs.go = {
    enable = true;
    goPath = "Dev";
    goBin = "Dev/bin";
    goPrivate = [ "lab.weave.nl" ];
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
      tmutil addexclusion $(direnv_layout_dir)

      layout_poetry() {
        export POETRY_VIRTUALENVS_PATH="$(direnv_layout_dir)/poetry"
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
