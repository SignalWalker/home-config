{
  config,
  pkgs,
  lib,
  profile,
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
      network.listenAddress = "[::1]:6600";
      extraConfig = ''
        bind_to_address "@mpd"
        auto_update "yes"
        audio_output {
          type "pipewire"
          name "pipewire audio"
        }
      '';
    };
    services.mpdris2 = {
      enable = config.services.mpd.enable;
      notifications = profile.graphical;
      multimediaKeys = false;
    };
  };
}
