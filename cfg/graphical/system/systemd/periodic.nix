inputs @ {
  config,
  pkgs,
  utils,
  ...
}:
with builtins; let
  std = pkgs.lib;
in {
  systemd.user.timers = {
    "check-battery@" = {
      Unit.Description = "battery level notification";
      Unit.PartOf = "graphical-session.target";
      Timer.OnUnitActiveSec = "60s";
      Timer.OnActiveSec = "0s";
      Install.WantedBy = ["graphical-session.target"];
    };
  };
  systemd.user.services = {
    "check-battery@" = {
      Service.Type = "oneshot";
      Service.ExecStart = "${pkgs.ash-scripts.rust.check-battery}/bin/check-battery -l Info -n Info -s 6.0 %i";
    };
  };
}
