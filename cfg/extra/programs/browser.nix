{
  config,
  pkgs,
  lib,
  profile,
  impure,
  utils,
  ...
}:
with builtins; let
  std = pkgs.lib;
in {
  options = with lib; {};
  imports = [];
  config = lib.optionalAttrs profile.graphical {
    home.packages = with pkgs; [
      vivaldi
      # vivaldi-widevine
      vivaldi-ffmpeg-codecs
    ];
  };
}
