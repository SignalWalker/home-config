inputs @ {
  config,
  pkgs,
  utils,
  ...
}: {
  imports = utils.listFiles ./programs;
  config = {
    home.packages = with pkgs; [
      # terminal
      ## meta
      vivid
      mosh
      ## util
      btop
      ripgrep
      ripgrep-all
      fd
      ## debug
      strace
    ];

    programs.git = {
      enable = true;
      lfs.enable = true;
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

    programs.gpg = {
      enable = true;
      homedir = "${config.xdg.configHome}/gnupg";
    };

    services.kdeconnect.enable = true;

    programs.info.enable = true;
  };
}
