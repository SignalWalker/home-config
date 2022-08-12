{
  config,
  pkgs,
  lib,
  utils,
  ...
}:
with builtins; let
  std = pkgs.lib;
in {
  options = with lib; {};
  imports = utils.listFiles ./base;
  config = {
    dev = {
      enable = true;
      editor.neovim.enable = true;
      cache.enable = true;
      linker.enable = true;
      lang.c.enable = true;
      lang.haskell.enable = true;
      lang.js.enable = true;
      lang.nix.enable = true;
      lang.rust.enable = true;
      lang.zig.enable = true;
    };
  };
}
