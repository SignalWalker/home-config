inputs @ {nixpkgs}:
with builtins; let
  std = nixpkgs.lib;
  attrIfSome = opt: attrs: std.optionalAttrs (opt != null) attrs;
  listIfSome = opt: list: std.optionals (opt != null) list;
  listFiles' = dir: let
    entries = readDir dir;
  in (filter (name: entries.${name} != "directory") (attrNames entries));
  # some = value: { hasVal = true; inherit value; };
  # none = value { hasVal = false; value = null; };
  filterMap = fn: vals:
    std.foldl
    (
      res: val: let
        fres = fn val;
      in
        if fres.isSome
        then (res ++ [fres.value])
        else res
    )
    []
    vals;
in rec {
  inherit
    attrIfSome
    listIfSome
    filterMap
    ;

  inherit listFiles';
  listFiles = dir: map (name: dir + "/${name}") (listFiles' dir);
  listNix = dir: map (name: dir + "/${name}") (listFiles' dir);

  listContains = obj: list: any (el: el == obj) list;
  mkOutputList' = let
    oldDefaults = {
      "overlays" = "overlay";
      "nixosModules" = "nixosModule";
      "packages" = "defaultPackage";
      "apps" = "defaultApp";
    };
  in
    output: keys: flake:
      (
        if (flake ? "${output}")
        then
          (std.foldl (acc: key:
            acc
            ++ (
              if flake.${output} ? "${key}"
              then [flake.${output}.${key}]
              else []
            )) []
          keys)
        else []
      )
      ++ (
        if ((oldDefaults ? "${output}") && (flake ? "${oldDefaults.${output}}") && (listContains "default" keys))
        then [flake.${oldDefaults.${output}}]
        else []
      );
  mkOutputList = output: keys: flakes: concatLists (map (mkOutputList' output keys) flakes);
  mkOverlayList' = keys: flakes: mkOutputList "overlays" keys flakes;
  mkOverlayList = system: flakes: mkOverlayList' [system "default"] flakes;

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
