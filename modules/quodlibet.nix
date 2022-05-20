{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
in {
  options = {
    programs.quodlibet = with lib; {
      enable = mkEnableOption "quodlibet music player";
      package = mkOption {
        type = types.package;
        default = pkgs.quodlibet;
        defaultText = literalExpression "pkgs.quodlibet";
        description = "The quodlibet package to install.";
      };
    };
  };
  config = lib.mkIf config.programs.quodlibet.enable (
    let
      cfg = config.programs.quodlibet;
    in {
      home.packages = [cfg.package];
    }
  );
}
