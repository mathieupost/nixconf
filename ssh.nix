{ config, lib, pkgs, ... }:

{
  programs.ssh = {
    enable = true;
    extraOptionOverrides = {
      IdentityFile = "~/.ssh/id_rsa";
      AddKeysToAgent = "yes";
      Include = "~/.ssh/gce_config";
    };
  };
}
# vim: sw=2 sts=2 ts=2 fdm=indent expandtab
