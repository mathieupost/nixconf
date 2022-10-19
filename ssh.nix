{ config, lib, pkgs, ... }:

{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      versio = {
        hostname = "vserver90.axc.eu";
        user = "mathikx90";
      };
      satellite = {
        hostname = "192.168.178.90";
        user = "mathieu";
      };
    };
    extraOptionOverrides = {
      IdentityFile = "~/.ssh/id_rsa";
      AddKeysToAgent = "yes";
    };
  };
}
# vim: sw=2 sts=2 ts=2 fdm=indent expandtab
