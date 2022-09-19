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

    theme.enable = true;

    # services.wayland = {
    #   enable = true;
    #   xwayland.enable = true;
    #   taskbar.enable = true;
    #   notifications.enable = true;
    #   menu.enable = true;
    #   wallpaper = {
    #     enable = true;
    #     default-bg = ../res/pond.png;
    #   };
    #   compositor = {
    #     sway.enable = true;
    #     river.enable = true;
    #     hyprland.enable = false;
    #   };
    # };

    # wayland.windowManager.hyprland = lib.mkIf impure {
    #   package = pkgs.wrapSystemApp { app = "Hyprland"; };
    # };

    services.X11 = {
      enable = true; # !config.services.wayland.enable;
      dunst = {
        enable = !config.services.wired.enable;
        font = let
          font = config.theme.font.bmp."8";
        in {
          inherit (font) name package size;
        };
      };
      compositor.enable = true;
      taskbar.enable = true;
      rofi.enable = true;
      wired.enable = false;
    };
  };
}
