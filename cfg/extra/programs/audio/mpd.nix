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
  config = let
    music = config.xdg.userDirs.music;
  in {
    services.mpd = {
      enable = true;
      dataDir = "${config.xdg.dataHome}/mpd";
      musicDirectory = "${music}/library";
      playlistDirectory = "${music}/playlists";
      network.startWhenNeeded = true;
    };
    services.mpdris2 = {
      enable = config.services.mpd.enable;
      notifications = true;
      multimediaKeys = true;
    };
  };
}
