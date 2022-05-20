inputs @ {
  config,
  pkgs,
  utils,
  ...
}:
with builtins; {
  imports = utils.listFiles ./graphical;
  services.blueman-applet.enable = true;
  services.kdeconnect.indicator = config.services.kdeconnect.enable;
}
