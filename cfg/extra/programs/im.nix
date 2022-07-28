{
  config,
  pkgs,
  lib,
  profile,
  ...
}:
with builtins; let
  std = pkgs.lib;
in {
  options = with lib; {};
  imports = [];
  config = lib.optionalAttrs profile.graphical {
    home.packages = with pkgs; [
      discord-canary
      element-desktop
    ];
  };
}
