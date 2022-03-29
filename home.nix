inputs@{ config, pkgs, ... }:

{
  imports = [
    # inputs.nixvim.homeManagerModules.nixvim
  ];
  # home.username = "jdoe";
  # home.homeDirectory = "/home/jdoe";

  home.packages = with pkgs; [
    # terminal
    ## meta
    starship
    vivid
    zellij
    mosh
    ## util
    btop
    bat
    ripgrep
    ripgrep-all
    lsd
    fd
    nvimpager
  ];

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "Ash Walker";
    userEmail = "ash@ashwalker.net";
    extraConfig = {
      core = {
        autocrlf = "input";
      };
      init = {
        defaultBranch = "main";
      };
      pull = {
        rebase = true;
      };
    };
  };

  # graphical

  programs.kitty = import ./kitty.nix inputs;

  # programs.nixvim = {
  #   enable = true;
  #   package = pkgs.neovim;
  #   colorschemes.gruvbox = {
  #     enable = true;
  #     bold = true;
  #     italics = true;
  #     undercurl = true;
  #     underline = true;
  #     trueColor = true;
  #     contrastDark = "hard";
  #     contrastLight = "hard";
  #     transparentBg = true;
  #     improvedStrings = true;
  #     improvedWarnings = true;
  #   };
  #   options = {
  #     number = true;
  #   };
  #   maps = {
  #     normal = { };
  #   };
  # };
}
