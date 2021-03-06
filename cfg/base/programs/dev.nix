{
  config,
  pkgs,
  lib,
  utils,
  profile,
  ...
}:
with builtins; let
  std = pkgs.lib;
in {
  options = with lib; {
  };
  imports = utils.listFiles ./dev;
  config = {
    home.packages = with pkgs; [
      ## git
      gitoxide
      gh
      glab
      ## debug
      strace
    ];
  };
}
