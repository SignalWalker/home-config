inputs @ {
  config,
  pkgs,
  utils,
  ...
}:
with builtins; let
  std = pkgs.lib;
in {
  services.check-battery = {
    enable = true;
  };
}
