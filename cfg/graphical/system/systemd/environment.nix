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
      # VK_ICD_FILENAMES = "/usr/share/vulkan/icd.d/nvidia_icd.json";
    };
  };
}
