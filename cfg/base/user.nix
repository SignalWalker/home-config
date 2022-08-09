inputs @ {
  config,
  pkgs,
  profile,
  lib,
  ...
}: {
  options = with lib; {};
  imports = [];
  config = {
    accounts.email.accounts = {
      primary = {
        address = "ashurstwalker@gmail.com";
        flavor = "gmail.com";
        primary = true;
      };
      secondary = {
        address = "protomith@gmail.com";
        flavor = "gmail.com";
      };
      personal = {
        address = "ash@ashwalker.net";
      };
    };
    programs.git = {
      userName = "Ash Walker";
      userEmail = config.accounts.email.accounts.primary.address;
      extraConfig = {
        merge.conflictStyle = "diff3";
      };
    };
  };
}
