{
  config,
  pkgs,
  lib,
  utils,
  ...
}:
with builtins; let
  std = pkgs.lib;
in {
  options = with lib; {};
  imports = utils.listFiles ./programs;
  config = {
    home.packages = with pkgs; [
      jq
    ];
  };
}
