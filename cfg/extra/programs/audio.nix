{
  config,
  pkgs,
  lib,
  utils,
  ...
}:
with builtins; {
  imports = utils.listFiles ./audio;
}
