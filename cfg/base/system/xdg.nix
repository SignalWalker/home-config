inputs @ {
  config,
  pkgs,
  utils,
  ...
}: {
  imports = utils.listFiles ./xdg;
  xdg = {
    enable = true;
    cacheHome = ~/.cache;
    configHome = ~/.config;
    stateHome = ~/.local/state;
    dataHome = ~/.local/share;
    userDirs = let
      home = config.home.homeDirectory;
    in {
      enable = true;
      createDirectories = true;
      desktop = "${home}/desktop";
      documents = "${home}/documents";
      download = "${home}/downloads";
      music = "${home}/music";
      pictures = "${home}/pictures";
      publicShare = "${home}/public";
      templates = "${home}/templates";
      videos = "${home}/videos";
      extraConfig = {
        XDG_PROJECT_DIR = "${home}/projects";
        XDG_NOTE_DIR = "${home}/notes";
        XDG_BACKUP_DIR = "${home}/backup";
        XDG_SOURCE_DIR = "${home}/src";
        XDG_GAME_DIR = "${home}/games";
        XDG_NIX_DIR = "${home}/.nix_profile";
      };
    };
  };
}
