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
  imports = [];
  config = let
    scripts = utils.listFiles' ./scripts;
  in {
    home.file = std.genAttrs scripts (script: {
      executable = true;
      target = ".local/bin/${script}";
      source = ./scripts/${script};
    });
  };
}
