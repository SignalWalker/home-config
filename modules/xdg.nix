{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
in {
  options.xdg.userDirs.templateFile = with lib;
    mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          text = mkOption {type = types.str;};
          target = mkOption {type = types.str;};
        };
      });
      default = {};
    };
  config.home.file =
    std.mapAttrs'
    (name: file:
      std.nameValuePair "${config.xdg.userDirs.templates}/${name}" (file
        // {
          target = "${config.xdg.userDirs.templates}/${file.target}";
        }))
    config.xdg.userDirs.templateFile;
}
