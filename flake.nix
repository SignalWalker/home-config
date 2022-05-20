{
  description = "Ash Walker's Home Manager config";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixpkgs-unstable;
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # inputs
    nix = {
      url = github:nixos/nix?ref=2.8.0;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mozilla = {
      url = github:mozilla/nixpkgs-mozilla;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ## neovim
    neovim = {
      url = github:neovim/neovim?dir=contrib;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvimpager = {
      url = github:lucc/nvimpager;
      inputs.neovim.follows = "neovim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ## games
    archive = {
      url = github:signalwalker/nix-internet-archive;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    roms = {
      url = github:signalwalker/nix-roms;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.archive.follows = "archive";
    };
    modloader64 = {
      url = github:signalwalker/nix-modloader64;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ## misc
    statix = {
      # url = git+https://git.peppe.rs/languages/statix;
      url = github:nerdypepper/statix;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    alejandra = {
      url = github:kamadorueda/alejandra;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rnix-lsp = {
      url = github:nix-community/rnix-lsp;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ash-scripts = {
      url = github:signalwalker/scripts-rs;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.mozilla.follows = "mozilla";
    };
    xmonad-ash = {
      url = github:signalwalker/xmonad-config;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    polybar-scripts = {
      url = github:polybar/polybar-scripts;
      flake = false;
    };
    wired = {
      # url = github:Toqozz/wired-notify;
      url = git+file:///home/ash/src/wired-notify;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    mozilla,
    ...
  }:
    with builtins; let
      std = nixpkgs.lib;
      utils = import ./src/utils.nix {inherit nixpkgs;};
      systems = ["x86_64-linux"];
      genSystems = fn: std.genAttrs systems fn;
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
      nixpkgsFor = genSystems (system:
        import nixpkgs {
          inherit system;
          overlays =
            [
              mozilla.overlays.rust
              mozilla.overlays.firefox
            ]
            ++ filterMap
            (flake: {
              isSome = flake ? overlay || (flake ? overlays && (flake.overlays ? ${system} || flake.overlays ? default));
              value = flake.overlay or (flake.overlays.default or flake.overlays.${system});
            })
            (with inputs; [
              nix
              neovim
              nvimpager
              statix
              alejandra
              rnix-lsp
              ash-scripts
              # xmonad-ash
              roms
              modloader64
              archive
              wired
            ]);
        });
      utilsFor = std.mapAttrs (system: pkgs: import ./src/utils.nix {inherit nixpkgs pkgs;}) nixpkgsFor;
      mapSelf =
        std.foldl
        (
          acc: aname:
            acc
            // (
              let
                base = fn: std.mapAttrs fn self.${aname};
                base' = fn: std.mapAttrs' fn self.${aname};
              in {
                ${aname} = base;
                "${aname}'" = base';
                "${aname}Sys" = fn: base (system: valSet: std.mapAttrs fn valSet);
                "${aname}Sys'" = fn: base (system: valSet: std.mapAttrs' fn valSet);
              }
            )
        )
        {}
        (attrNames self);
      baseProfile = system: {
        extraSpecialArgs = {
          impure = false;
          username = "ash";
          utils = utilsFor.${system};
          profile = {
            utility = false;
            graphical = false;
            extra = false;
          };
          extraInputs = {
            inherit (inputs) polybar-scripts;
          };
          resources = {
            pond = ./res/pond.png;
          };
        };
      };
      homeConfigs = let
        _base = {
          "minimal" = system: {};
          "server" = system: {
            extraSpecialArgs.profile = {
              utility = true;
            };
          };
          "usb" = system: {
            extraSpecialArgs.profile = {
              utility = true;
              graphical = true;
            };
          };
          "desktop" = system: {
            extraSpecialArgs.profile = {
              utility = true;
              graphical = true;
              extra = true;
            };
          };
        };
        base =
          std.mapAttrs (name: fn: system: std.recursiveUpdate (baseProfile system) (fn system))
          _base;
      in (base
        // (std.mapAttrs' (profile: baseFn: {
            name = "${profile}-impure";
            value = system: let
              pbase = baseFn system;
            in
              std.recursiveUpdate pbase {extraSpecialArgs.impure = true;};
          })
          base));
      mapHMConfigs = fn: std.mapAttrs fn homeConfigs;
      mapSysHmConfigs = fn: system: mapHMConfigs (user: cfgFn: fn (cfgFn system));
    in {
      formatter = std.mapAttrs (system: pkgs: pkgs.default) inputs.alejandra.packages;
      homeConfigurations = genSystems (
        system: (
          mapHMConfigs (
            profile: cfgFn:
              home-manager.lib.homeManagerConfiguration (
                std.recursiveUpdate {
                  inherit system;
                  username = "ash";
                  homeDirectory = "/home/ash";
                  # Update the state version as needed.
                  # See the changelog here:
                  # https://nix-community.github.io/home-manager/release-notes.html#sec-release-21.05
                  stateVersion = "22.05";
                  pkgs = nixpkgsFor.${system};
                  extraModules =
                    [
                      inputs.modloader64.homeManagerModules.default
                      inputs.wired.homeManagerModules.default
                    ]
                    ++ (map (file: import file) (utils.listFiles ./mod));
                  configuration = import ./cfg/home.nix;
                } (cfgFn system)
              )
          )
        )
      );
      packages =
        mapSelf.homeConfigurationsSys
        (profile: cfg: cfg.activationPackage);
      apps =
        mapSelf.packagesSys'
        (profile: pkg:
          std.nameValuePair "activate-${profile}" {
            type = "app";
            program = "${pkg}/activate";
          });
    };
}
