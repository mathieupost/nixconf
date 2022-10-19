# Git settings
{ config, lib, pkgs, cacert, ... }:

{
  programs.git = {
    package = pkgs.gitAndTools.gitFull;
    enable = true;
    userName = "Mathieu Post";
    userEmail = "mathieupost@gmail.com";
    signing.key = "3D10CCF4CFF59E21";
    signing.signByDefault = true;

    includes = [{
      condition = "gitdir:~/Dev/src/lab.weave.nl/**/.git";
      contents = {
        user = {
          email = "mathieu@weave.nl";
          signingKey = "66504F65E6311838";
        };
      };
    }];

    ignores = [
      ".DS_Store"
      "._*"
      ".ignore"
      ".pre-commit-config.yaml"
      ".envrc"
      ".direnv/"
      ".nix/"
      "result" # nix flake result file
    ];

    aliases = {
      gl = "!git --no-pager log -10 --graph --pretty=\"%Cred%h%C(yellow)%d%Creset %s %Cgreen(%cr) %C(blue)<%an>%Creset\"";
      wip = "!git add -A && git commit -m 'WIP'";
      undo = "reset HEAD~1 --mixed";
      wipe = "!git add -A && git commit -qm 'WIPE SAVEPOINT' && git reset HEAD~1 --hard";
      fixup = "!f() { git commit --fixup \${1} && git rebase \${1}~1 -i --autosquash; }; f";
      stash-staged = "!git stash --keep-index && git stash push -m 'staged' --keep-index && git stash pop stash@{1}";
      log-since-last-tag = "!git log $(git describe origin/master --tags --abbrev=0)..origin/master --oneline";
      log-since-last-tag-main = "!git log $(git describe origin/main --tags --abbrev=0)..origin/main --oneline";
      open = "!open $(git config --get remote.origin.url | sed 's%:%/%g' | sed 's%git@%https://%g' | sed 's%\.git%%g')";
    };

    extraConfig = {
      credential.helper = "osxkeychain";

      core = {
        editor = "vim";
      };

      pull.rebase = "true";
      rebase.autostash = "true";

      merge.tool = "vimdiff";
      merge.conflictstyle = "diff3";
    };
  };
}
# vim: sw=2 sts=2 ts=2 fdm=indent noexpandtab
