{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.dev.lang.c;
in {
  options.dev.lang.c = with lib; {
    enable = mkEnableOption "C/C++ language family";
    llvmPackages = mkOption {
      type = types.package;
      default = pkgs.llvmPackages_14;
    };
  };
  imports = [];
  config = lib.mkIf (config.dev.enable && cfg.enable) {
    home.packages = [
      cfg.llvmPackages.clang
      cfg.llvmPackages.clang-manpages
    ] ++ (with pkgs; [
      cmake
      cmake-format
      cmake-language-server
    ]);
    systemd.user.sessionVariables = {
      CC = "clang";
      CXX = "clang++";
      CMAKE_EXPORT_COMPILE_COMMANDS = "ON";
    };
  };
}
