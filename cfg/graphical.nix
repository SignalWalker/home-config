inputs @ {
  config,
  pkgs,
  utils,
  lib,
  impure ? false,
  ...
}:
with builtins; {
  imports = utils.listFiles ./graphical;
  config = {
    services.blueman-applet.enable = true;
    services.kdeconnect.indicator = config.services.kdeconnect.enable;

    services.wayland = {
      enable = true;
      xwayland.enable = true;
      taskbar.enable = true;
      notifications.enable = true;
    };

    wayland.windowManager.hyprland = lib.mkIf impure {
      package = pkgs.wrapSystemApp { app = "Hyprland"; };
    };

    services.X11 = {
      enable = true; # !config.services.wayland.enable;
      dunst = {
        enable = !config.services.wired.enable;
        font = {
          package = pkgs.curie;
          name = "curie";
          size = 8;
        };
      };
      compositor.enable = true;
      rofi.enable = true;
      wired.enable = true;
    };
  };
}
