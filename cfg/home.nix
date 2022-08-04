inputs @ {
  config,
  pkgs,
  lib,
  profile,
  ...
}:
with builtins; let
  std = lib;
in {
  options = {};
  imports =
    [
      ./base.nix
    ]
    ++ (
      std.optional profile.utility ./utility.nix
    )
    ++ (
      std.optional profile.graphical ./graphical.nix
    )
    ++ (
      std.optional profile.extra ./extra.nix
    );

  config = {
    programs.home-manager.enable = true;
    home.enableNixpkgsReleaseCheck = true;
    manual = {
      html.enable = true;
      manpages.enable = true;
      json.enable = true;
    };
    news = {
      display = "notify";
    };
  };
}
