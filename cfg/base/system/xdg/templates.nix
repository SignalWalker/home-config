{
  config,
  pkgs,
  lib,
  ...
}: {
  xdg.userDirs.templateFile."hm-module" = {
    text = ''
      { config, pkgs, lib, ... }: with builtins; let
        std = pkgs.lib;
      in {
        options = with lib; {};
        imports = [];
        config = {};
      }
    '';
    target = "hm-module.nix";
  };
  xdg.userDirs.templateFile."flake" = {
    text = ''
      {
        description = "";
        inputs = {
          nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;
        };
        outputs = { self, nixpkgs }: with builtins; let
          std = nixpkgs.lib;
        in {

        };
      }
    '';
    target = "flake.nix";
  };
}
