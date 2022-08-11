{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
in {
  options = with lib; {};
  imports = [];
  config = {
    systemd.user.sessionVariables = {
      MOZ_DBUS_REMOTE = 1;
      # VK_ICD_FILENAMES = "/usr/share/vulkan/icd.d/nvidia_icd.json";
    };
  };
}
