{
  config,
  pkgs,
  lib,
  profile,
  ...
}:
with builtins; {
  config = lib.mkIf profile.graphical {
    home.file."sxrc" = lib.mkForce {
      text = let
        ssnpath = "${config.home.homeDirectory}/${config.xsession.scriptPath}";
      in ''
        #! /usr/bin/env sh
        logger -t sx "Running ${ssnpath}"
        . ${ssnpath}
      '';
      target = ".config/sx/sxrc";
      executable = true;
    };
    xsession = let
      xmonad = "xmonad";
    in {
      enable = config.services.X11.enable;
      scriptPath = ".config/xsession";
      profilePath = ".config/xprofile";
      numlock.enable = true;
      preferStatusNotifierItems = true;
      windowManager.command = "${xmonad}";
      # windowManager.xmonad = {
      #   enable = true;
      #   enableContribAndExtras = true;
      # };
    };
  };
}
