# Shell configuration
{ config, lib, pkgs, goBuildModule, ... }:

{
  home.packages = with pkgs; [
    fzf
    any-nix-shell # fish and zsh support for nix-shell
    comma # run everything with "," without installing
    thefuck
    babelfish # convert POSIX to fish
    ttyd # shell in your browser
  ];

  programs.bash.enable = true;
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    autocd = true;
  };
  programs.fish = {
    enable = true;
    shellAliases = {
      fish_title = "prompt_pwd"; # set terminal window title
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
      "......" = "cd ../../../../..";
      zf = "z --pipe=fzf";
      darwin-switch = "darwin-rebuild switch --flake ~/.config/nixconf";
    };
    plugins = with pkgs.fishPlugins; [
      { name = "fzf"; src = fzf-fish.src; } # better than buit-in fzf keybinds
    ];
    shellInit = ''
      any-nix-shell fish --info-right | source
      thefuck --alias | source
      fish_add_path /opt/homebrew/bin
    '';
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
  };

  programs.starship = {
    enable = true;
    settings = {
      cmd_duration.min_time = 500;
      command_timeout = 1000;
      gcloud.disabled = true;
      docker_context.disabled = true;
      buf.disabled = true;
      nix_shell.format = "via [\$symbol\$state](\$style) ";
      nix_shell.symbol = "❄️ ";
      kubernetes = {
        disabled = false;
      };
    };
  };

  programs.pazi.enable = true;
  programs.dircolors.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    stdlib = ''
      tmutil addexclusion $(direnv_layout_dir)
    '';
  };
  programs.fzf = {
    enable = true;
    enableFishIntegration = false; # use fzf-fish plugin instead
  };
}
# vim: sw=2 sts=2 ts=2 fdm=indent expandtab
