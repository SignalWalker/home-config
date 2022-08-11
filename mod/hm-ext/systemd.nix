{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
in {
  options.home.environment = with lib; {

  };
  imports = [];
  config = {};
}
