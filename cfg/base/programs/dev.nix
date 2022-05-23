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
    home.packages = with pkgs; ([
        gitoxide
        ## git
        gh
        glab
        ## debug
        strace
      ]
      ++ (lib.optionals profile.graphical [
        zeal
      ]));
  };
}
