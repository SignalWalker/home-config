{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.dev;
in {
  options = with lib; {
    enable = mkEnableOption "development environment configuration";
  };
  imports = [
    ./dev/ccache.nix
    ./dev/direnv.nix
    ./dev/git.nix
    ./dev/lang.nix
    ./dev/neovim.nix
  ];
  config = lib.mkif cfg.enable {
    home.packages = with pkgs; [
      # debug
      strace
    ];
  };
}
