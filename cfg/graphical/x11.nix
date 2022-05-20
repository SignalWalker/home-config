inputs @ {
  config,
  pkgs,
  utils,
  ...
}:
with builtins; let
  std = pkgs.lib;
in {
  imports = utils.listFiles ./x11;
  config = {
    services.X11 = {
      enable = true;
      dunst = {
        enable = !config.services.wired.enable;
        font = {
          package = pkgs.curie;
          name = "curie";
          size = 8;
        };
      };
      compositor.enable = true;
    };
  };
}
