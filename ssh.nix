{ config, lib, pkgs, ... }:
let
  authSocket = "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
in
{
  home.sessionVariables = {
    SSH_AUTH_SOCK = authSocket;
  };
  programs.ssh = {
    enable = true;
    extraOptionOverrides = {
      IdentityAgent = "\"${authSocket}\"";
    };
  };
}
# vim: sw=2 sts=2 ts=2 fdm=indent expandtab
