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
  };
}
