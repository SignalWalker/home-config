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
    "hydrate@" = {
      Unit.Description = "hydration reminder notification";
      Unit.PartOf = "graphical-session.target";
      Timer.OnUnitActiveSec = "%i";
      Timer.OnActiveSec = "0s";
      Timer.Persistent = true;
      Install.WantedBy = ["graphical-session.target"];
    };
    "check-battery@" = {
      Unit.Description = "battery level notification";
      Unit.PartOf = "graphical-session.target";
      Timer.OnUnitActiveSec = "60s";
      Timer.OnActiveSec = "0s";
      Install.WantedBy = ["graphical-session.target"];
    };
  };
  systemd.user.services = {
    "hydrate@" = {
      Service.Type = "oneshot";
      Service.ExecStart = utils.send-notification {
        notify-send = "${pkgs.libnotify}/bin/notify-send";
        summary = "Water!";
        stack = "hydrate";
        app = "hydrate-reminder";
        category = "reminder";
      };
    };
    "check-battery@" = {
      Service.Type = "oneshot";
      Service.ExecStart = "${pkgs.ash-scripts.rust.check-battery}/bin/check-battery -l Info -n Info -s 6.0 %i";
    };
  };
}
