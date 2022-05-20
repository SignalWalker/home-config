inputs @ {
  config,
  pkgs,
  lib,
  profile,
  ...
}:
with builtins; {
  options = {};
  imports =
    [
      ./base.nix
    ]
    ++ (
      if profile.utility
      then [
        ./utility.nix
      ]
      else []
    )
    ++ (
      if profile.graphical
      then [
        ./graphical.nix
      ]
      else []
    )
    ++ (
      if profile.extra
      then [
        ./extra.nix
      ]
      else []
    );

  config = {
    programs.home-manager.enable = false;
    home.enableNixpkgsReleaseCheck = true;
    manual = {
      html.enable = true;
      manpages.enable = true;
    };
  };
}
