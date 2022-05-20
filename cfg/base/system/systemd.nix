inputs @ {
  config,
  pkgs,
  utils,
  ...
}: {
  imports = utils.listFiles ./systemd;
  systemd.user.systemctlPath = "/usr/bin/systemctl";
  systemd.user.startServices = "sd-switch";
}
