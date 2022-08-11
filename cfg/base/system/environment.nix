{
  config,
  pkgs,
  ...
}:
with builtins; {
  config = {
    home.sessionPath = [
      "${home}/.local/bin"
    ];
    home.sessionVariables = config.systemd.user.sessionVariables;
  };
}
