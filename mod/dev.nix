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
  options.dev = with lib; {
    enable = mkEnableOption "development environment configuration";
  };
  imports = [
    ./dev/cache.nix
    ./dev/direnv.nix
    ./dev/git.nix
    ./dev/lang.nix
    ./dev/linker.nix
    ./dev/neovim.nix
  ];
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # debug
      strace
    ];
  };
}
