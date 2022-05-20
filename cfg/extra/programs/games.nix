{
  config,
  pkgs,
  lib,
  profile,
  utils,
  ...
}:
with builtins; let
  std = pkgs.lib;
in {
  options = with lib; {};
  imports = utils.listFiles ./games;
  config = {};
}
