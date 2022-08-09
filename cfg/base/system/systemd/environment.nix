inputs @ {
  config,
  pkgs,
  utils,
  ...
}:
with builtins; {
  systemd.user.sessionVariables = let
    home = config.home.homeDirectory;
    npm_config_prefix = "${home}/.local/npm";
    cfg = config.systemd.user.sessionVariables;
  in {
    PATH = concatStringsSep ":" [
      "${home}/.local/bin"
      "${home}/.cargo/bin"
      "${home}/.cabal/bin"
      "${npm_config_prefix}/bin"
      "$PATH"
    ];
    CC = "clang";
    CXX = "clang++";
    CMAKE_EXPORT_COMPILE_COMMANDS = "ON";
    inherit npm_config_prefix;
    EDITOR = "nvim";
    VISUAL = "nvim";
    MOZ_DBUS_REMOTE = 1;
  };
}
