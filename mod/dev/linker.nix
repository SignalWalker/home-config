{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.dev.linker;
in {
  options.dev.linker = with lib; {
    enable = mkEnableOption "linker configuration";
  };
  imports = [];
  config = lib.mkIf (config.dev.enable && cfg.enable) {
    home.packages = with pkgs; [
      mold
    ];
    systemd.user.sessionVariables = lib.mkMerge [
      {
        LDFLAGS = "-fuse-ld=mold";
      }
      (lib.mkIf config.dev.lang.c.enable {
        CC_LD = "mold"; # meson
        CXX_LD = "mold"; # meson
      })
      (lib.mkIf config.dev.lang.rust.enable {
        RUSTC_LD = "mold"; # meson
      })
    ];
    dev.lang.rust.cargo.linker = "mold";
  };
}
