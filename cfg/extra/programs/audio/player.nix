{
  config,
  pkgs,
  lib,
  utils,
  profile,
  ...
}:
with builtins; let
in {
  config = {
    programs.quodlibet = {
      enable = false; # profile.graphical;
      package = pkgs.quodlibet-full;
    };
    programs.ncmpcpp = {
      enable = config.services.mpd.enable;
      package = pkgs.ncmpcpp.override {visualizerSupport = true;};
    };
  };
}
