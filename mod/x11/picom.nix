inputs@{
  config,
  pkgs,
  lib,
  impure ? false,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.services.X11;
in {
  options.services.X11.compositor = with lib; {
    enable = (mkEnableOption "compositor") // {default = true;};
  };
  imports = [];
  config = lib.mkIf (cfg.enable && cfg.compositor.enable) {
    services.picom = {
      enable = cfg.compositor.enable;
      package =
        if impure
        then (pkgs.wrapSystemApp {app = "picom";})
        else pkgs.picom;
    };
  };
}
