inputs @ {
  nixpkgs,
  pkgs ? null,
}:
with builtins; let
  std = nixpkgs.lib;
  attrIfSome = opt: attrs: std.optionalAttrs (opt != null) attrs;
  listIfSome = opt: list: std.optionals (opt != null) list;
  listFiles' = dir: let
    entries = readDir dir;
  in (filter (name: entries.${name} != "directory") (attrNames entries));
in ({
    inherit
      attrIfSome
      listIfSome
      ;

    inherit listFiles';
    listFiles = dir: map (name: dir + "/${name}") (listFiles' dir);

    send-notification = {
      summary,
      body ? null,
      stack ? null,
      app ? null,
      category ? null,
      timeout ? null,
      notify-send ? "notify-send",
    }:
      concatStringsSep " " ([
          notify-send
        ]
        ++ (map ({
          var,
          val,
        }:
          val) (filter ({
          var,
          val,
        }:
          var != null) [
          {
            var = timeout;
            val = "-t ${timeout}";
          }
          {
            var = stack;
            val = "-h string:x-dunst-stack-tag:${stack}";
          }
          {
            var = category;
            val = "-c ${category}";
          }
          {
            var = app;
            val = "-a ${app}";
          }
        ]))
        ++ [
          summary
        ]
        ++ (listIfSome body [
          body
        ]));
  }
  // (std.optionalAttrs (pkgs != null) {
    wrapSystemApp = {
      app,
      pname ? "system-${app}",
      syspath ? "/usr/bin/${app}",
    }:
      pkgs.runCommandLocal pname {} ''
        mkdir -p $out/bin
        ln -sT ${syspath} $out/bin/${app}
      '';
  }))
