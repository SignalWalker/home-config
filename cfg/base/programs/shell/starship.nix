{
  config,
  pkgs,
  ...
}: {
  programs.starship = let
    prg = config.programs;
  in {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = prg.fish.enable;
    enableIonIntegration = prg.ion.enable;
    enableZshIntegration = prg.zsh.enable;
    settings = {
      add_newline = false;
      right_format = "$time";
      sudo = rec {
        disabled = false;
        symbol = "⚿ ";
        format = "\\[${symbol}\\]";
      };

      time = rec {
        disabled = false;
        format = "⏱ [$time]($style)";
      };

      username = rec {
        format = "\\[[$user]($style)\\]";
      };

      status = rec {
        disabled = false;
      };

      memory_usage = rec {
        disabled = false;
        symbol = " ";
        format = "\\[${symbol}[$ram( | $swap)]($style)\\]";
      };

      directory = rec {
        truncate_to_repo = false;
        read_only = " ";
        fish_style_pwd_dir_length = 2;
      };

      shell = rec {
        disabled = false;
        fish_indicator = "";
        zsh_indicator = "↯";
        ion_indicator = "⚝";
        nu_indicator = "ǂ";
      };

      shlvl = rec {
        # disabled = false;
        symbol = " ";
      };

      battery.display = rec {
        threshold = 100;
        style = "yellow";
      };

      character = rec {
        success_symbol = "[☽](green)";
        error_symbol = "[☽](red)";
        vicmd_symbol = "[☾](green)";
      };

      cmd_duration = rec {
        format = "\\[[⏱ $duration]($style)\\]";
      };

      ### SPECIFIC

      aws = rec {
        symbol = "  ";
        format = "\\[[${symbol}($profile)(\\($region\\))(\\[$duration\\])]($style)\\]";
      };

      cmake = rec {
        format = "\\[[$symbol($version)]($style)\\]";
      };

      cobol = rec {
        format = "\\[[$symbol($version)]($style)\\]";
      };

      conda = rec {
        symbol = " ";
        format = "\\[[${symbol}$environment]($style)\\]";
      };

      crystal = rec {
        format = "\\[[$symbol($version)]($style)\\]";
      };

      dart = rec {
        symbol = " ";
        format = "\\[[${symbol}($version)]($style)\\]";
      };

      deno = rec {
        format = "\\[[$symbol($version)]($style)\\]";
      };

      docker_context = rec {
        symbol = " ";
        format = "\\[[${symbol}$context]($style)\\]";
      };

      dotnet = rec {
        format = "\\[[$symbol($version)(🎯 $tfm)]($style)\\]";
      };

      elixir = rec {
        symbol = " ";
        format = "\\[[${symbol}($version \\(OTP $otp_version\\))]($style)\\]";
      };

      elm = rec {
        symbol = " ";
        format = "\\[[${symbol}($version)]($style)\\]";
      };

      erlang = rec {
        format = "\\[[$symbol($version)]($style)\\]";
      };

      gcloud = rec {
        format = "\\[[$symbol$account(@$domain)(\\($region\\))]($style)\\]";
      };

      git_branch = rec {
        symbol = " ";
        format = "\\[[${symbol}$branch]($style)\\]";
      };

      git_status = rec {
        format = "([\\[$all_status$ahead_behind\\]]($style))";
      };

      golang = rec {
        symbol = " ";
        format = "\\[[${symbol}($version)]($style)\\]";
      };

      helm = rec {
        format = "\\[[$symbol($version)]($style)\\]";
      };

      hg_branch = rec {
        symbol = " ";
        format = "\\[[${symbol}$branch]($style)\\]";
      };

      java = rec {
        symbol = " ";
        format = "\\[[${symbol}($version)]($style)\\]";
      };

      julia = rec {
        symbol = " ";
        format = "\\[[${symbol}($version)]($style)\\]";
      };

      kotlin = rec {
        format = "\\[[$symbol($version)]($style)\\]";
      };

      kubernetes = rec {
        format = "\\[[$symbol$context( \\($namespace\\))]($style)\\]";
      };

      lua = rec {
        format = "\\[[$symbol($version)]($style)\\]";
      };

      nim = rec {
        symbol = " ";
        format = "\\[[${symbol}($version)]($style)\\]";
      };

      nix_shell = rec {
        symbol = " ";
        format = "\\[[${symbol}$state( \\($name\\))]($style)\\]";
      };

      nodejs = rec {
        symbol = " ";
        format = "\\[[${symbol}($version)]($style)\\]";
      };

      ocaml = rec {
        format = "\\[[$symbol($version)(\\($switch_indicator$switch_name\\))]($style)\\]";
      };

      openstack = rec {
        format = "\\[[$symbol$cloud(\\($project\\))]($style)\\]";
      };

      package = rec {
        symbol = " ";
        format = "\\[[${symbol}$version]($style)\\]";
      };

      perl = rec {
        symbol = " ";
        format = "\\[[${symbol}($version)]($style)\\]";
      };

      php = rec {
        symbol = " ";
        format = "\\[[${symbol}($version)]($style)\\]";
      };

      pulumi = rec {
        format = "\\[[$symbol$stack]($style)\\]";
      };

      purescript = rec {
        format = "\\[[$symbol($version)]($style)\\]";
      };

      python = rec {
        symbol = " ";
        # format = "\\[[${symbol}${pyenv_prefix}(${version})(\\($virtualenv\\))]($style)\\]"
      };

      red = rec {
        format = "\\[[$symbol($version)]($style)\\]";
      };

      ruby = rec {
        symbol = " ";
        format = "\\[[${symbol}($version)]($style)\\]";
      };

      rust = rec {
        symbol = " ";
        format = "\\[[${symbol}($version)]($style)\\]";
      };

      scala = rec {
        symbol = " ";
        format = "\\[[${symbol}($version)]($style)\\]";
      };

      swift = rec {
        symbol = "ﯣ ";
        format = "\\[[${symbol}($version)]($style)\\]";
      };

      terraform = rec {
        format = "\\[[$symbol$workspace]($style)\\]";
      };

      vagrant = rec {
        format = "\\[[$symbol($version)]($style)\\]";
      };

      vlang = rec {
        format = "\\[[$symbol($version)]($style)\\]";
      };

      zig = rec {
        format = "\\[[$symbol($version)]($style)\\]";
      };
    };
  };
}
