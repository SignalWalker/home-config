inputs @ {
  config,
  pkgs,
  utils,
  impure ? false,
  ...
}: {
  imports = utils.listFiles ./systemd;
  config = {
    systemd.user.systemctlPath = if impure then "/usr/bin/systemctl" else "${pkgs.systemd}/bin/systemctl";
    systemd.user.startServices = "sd-switch";
  };
}
