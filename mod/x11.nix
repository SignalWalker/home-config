inputs @ {
  config,
  pkgs,
  utils,
  impure,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
in {
  options.services.X11 = with inputs.lib; {
    enable = mkEnableOption "X11-specific configuration.";
  };
  imports = utils.listFiles ./x11;
  config = let
    cfg = config.services.X11;
  in
    lib.mkIf cfg.enable {
      programs.feh = {
        enable = true;
      };

      home.pointerCursor.x11 = {
        enable = true;
        defaultCursor = "left_ptr";
      };
    };
}
