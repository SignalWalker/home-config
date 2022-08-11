inputs @ {
  config,
  pkgs,
  utils,
  ...
}:
with builtins; {
  systemd.user.sessionVariables = let
    home = config.home.homeDirectory;
    cfg = config.systemd.user.sessionVariables;
  in {
  };
}
