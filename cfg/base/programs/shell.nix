{
  config,
  pkgs,
  utils,
  ...
}: let
  prg = config.programs;
in {
  imports = utils.listFiles ./shell;

  home.shellAliases = {
    ll = "${pkgs.lsd}/bin/lsd -lhF --group-dirs first --date '+%Y-%m-%d %H:%M:%S' -X";
  };

  programs.lsd = {
    enable = true;
  };

  programs.zellij = {
    enable = true;
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = prg.fish.enable;
    enableZshIntegration = prg.zsh.enable;
  };

  programs.bat = {
    enable = true;
  };

  programs.fzf = let
    fd = "${pkgs.fd}/bin/fd";
  in {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = prg.fish.enable;
    enableZshIntegration = prg.zsh.enable;
    defaultCommand = "${fd} --type f";
    fileWidgetCommand = "${fd} --type f --hidden --follow --exclude '.git'";
    changeDirWidgetCommand = "${fd} --type d --hidden --follow --exclude '.git'";
  };
}
