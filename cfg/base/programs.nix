inputs @ {
  config,
  pkgs,
  utils,
  ...
}: {
  imports = utils.listFiles ./programs;
  config = {
    home.packages = with pkgs; [
      btop
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

    programs.info.enable = true;
  };
}
