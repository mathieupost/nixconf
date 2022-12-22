{ config, lib, pkgs, ... }:

{
  programs.ssh = {
    enable = true;
    extraOptionOverrides = {
      IdentityAgent = "\"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"";
    };
  };
}
# vim: sw=2 sts=2 ts=2 fdm=indent expandtab
