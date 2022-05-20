{
  config,
  pkgs,
  ...
}:
with builtins; {
  home.sessionVariables = config.systemd.user.sessionVariables;
}
