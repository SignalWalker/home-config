inputs @ {
  config,
  pkgs,
  lib,
  options,
  ...
}:
with builtins; {
  config = {
    fonts.fontconfig.enable = true;
    gtk = {
      enable = true;
      font = {
        package = pkgs.iosevka;
        name = "Iosevka";
      };
      gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
      gtk3 = {
        bookmarks = map (dir: "file:///${config.xdg.userDirs.extraConfig.${dir}}") (attrNames config.xdg.userDirs.extraConfig);
      };
      iconTheme = {
        package = pkgs.gnome.adwaita-icon-theme;
        name = "Adwaita";
      };
      theme = {
        package = pkgs.gnome.gnome-themes-extra;
        name = "Adwaita";
      };
    };
    qt = {
      platformTheme = "gnome";
      style = {
        package = pkgs.adwaita-qt;
        name = "adwaita";
      };
    };
    home.pointerCursor = {
      # package = pkgs.nordzy-cursor-theme;
      # package = pkgs.quintom-cursor-theme;
      package = pkgs.vanilla-dmz;
      name = "Vanilla-DMZ-AA";
      gtk.enable = true;
      x11 = {
        enable = true;
        defaultCursor = "left_ptr";
      };
    };
  };
}
