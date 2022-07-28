{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
in {
  options = with lib; {};
  imports = [];
  config = {
    programs.fish = {
      enable = true;
    };

    programs.ion = {
      enable = true;
    };

    # programs.nushell = {
    #   enable = true;
    # };
  };
}
