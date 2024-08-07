# Git settings
{ config, lib, pkgs, cacert, ... }:

rec {
  home.file.".config/git/allowed_signers".text = ''
    mathieupost@gmail.com ${programs.git.signing.key}
  '';
  programs.git = {
    package = pkgs.gitAndTools.gitFull;
    enable = true;
    userName = "Mathieu Post";
    userEmail = "mathieupost@gmail.com";
    signing.key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBbeb4QZBgW72csW6GE4P0a/rDe7dSN/HOr4DY4bx2oO";
    signing.signByDefault = true;
    iniContent.gpg.format = "ssh";
    iniContent.gpg.ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
    iniContent.gpg.ssh.allowedSignersFile = "~/.config/git/allowed_signers";
    lfs.enable = true;

    ignores = [
      ".DS_Store"
      "._*"
      ".ignore"
      "flake.*"
      ".envrc"
      ".direnv/"
      ".null-ls_*"
      ".idea"
      ".vscode"
    ];

    aliases = {
      main = "!git branch --list master main | sed 's/^[* ] //'";
      wip = "!git add -A && git commit -m 'chore: work in progress (WIP)'";
      undo = "reset HEAD~1 --mixed";
      wipe = "!git add -A && git commit --no-verify --quiet -m 'WIPE SAVEPOINT' && git reset HEAD~1 --hard";
      fixup = "!f() { git commit --fixup \${1} && git rebase \${1}~1 -i --autosquash; }; f";
      stash-staged = "!git stash --keep-index && git stash push -m 'staged' --keep-index && git stash pop stash@{1}";
      log-graph = "!git --no-pager log -10 --graph --pretty=\"%Cred%h%C(yellow)%d%Creset %s %Cgreen(%cr) %C(blue)<%an>%Creset\"";
      log-since-last-tag = "!git log $(git describe origin/$(git main) --tags --abbrev=0)..origin/$(git main) --oneline";
      open = "!open $(git config --get remote.origin.url | sed 's%:%/%g' | sed 's%git@%https://%g' | sed 's%\\.git%%g')";
      fuzzy-checkout = "!git checkout --track $(git branch --all | fzf | tr -d \\[:space:\\])";
    };

    extraConfig = {
      core = {
        editor = "vim";
        excludesFile = "~/.config/git/ignore";
      };
      init.defaultBranch = "main";

      pull.rebase = "true";
      rebase.autostash = "true";
      rerere.enabled = "true"; # Reuse recorded resolution of conflicted merges
      push.autoSetupRemote = "true";

      merge.tool = "vimdiff";
      merge.conflictstyle = "diff3";
    };
  };
}
# vim: sw=2 sts=2 ts=2 fdm=indent expandtab
