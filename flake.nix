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
      url = github:nixos/nix/latest-release;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mozilla = {
      url = github:mozilla/nixpkgs-mozilla;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ## dev
    direnv = {
      url = github:direnv/direnv;
      flake = false;
    };
    nix-direnv = {
      url = github:nix-community/nix-direnv;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ### neovim
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
      url = github:signalwalker/internet-archive.nix;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # roms = {
    #   url = gitlab:signalwalker/roms.nix;
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.archive.follows = "archive";
    # };
    # modloader64 = {
    #   url = github:signalwalker/modloader64.nix;
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
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
    # xmonad-ash = {
    #   url = github:signalwalker/xmonad-config;
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    polybar-scripts = {
      url = github:polybar/polybar-scripts;
      flake = false;
    };
    wired = {
      url = github:Toqozz/wired-notify;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lsd = {
      url = github:SignalWalker/lsd;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # custom modules
    # wayland = {
    #   url = github:signalwalker/hm-wayland;
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.alejandra.follows = "alejandra";
    # };
    # zeal = {
    #   url = github:signalwalker/hm-zeal;
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.alejandra.follows = "alejandra";
    # };
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
      nixpkgsFor = genSystems (system:
        import nixpkgs {
          inherit system;
          overlays = self.lib.mkDefaultOverlayList system;
        });
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
      homeConfigs = let
        base = {
          "minimal" = {};
          "server".profile.utility = true;
          "usb".profile = {
            utility = true;
            graphical = true;
          };
          "desktop".profile = {
            utility = true;
            graphical = true;
            extra = true;
          };
        };
      in (base
        // (std.mapAttrs' (name: base: {
            name = "${name}-impure";
            value = base // {impure = true;};
          })
          base));
      mapHMConfigs = fn: std.mapAttrs fn homeConfigs;
      mapSysHmConfigs = fn: system: mapHMConfigs (user: cfgFn: fn (cfgFn system));
      rawInputs = {
        inherit (inputs) polybar-scripts direnv;
      }; # std.filterAttrs (input: attrs: !(attrs.flake or true)) inputs;
      overlayInputs = removeAttrs inputs ([
          "nixpkgs"
          "home-manager"
          "mozilla"
        ]
        ++ (attrNames rawInputs));

      # Update the state version as needed.
      # See the changelog here:
      # https://nix-community.github.io/home-manager/release-notes.html#sec-release-21.05
      stateVersion = "22.11";
    in {
      formatter = std.mapAttrs (system: pkgs: pkgs.default) inputs.alejandra.packages;
      overlays.default = final: prev: {
        wrapSystemApp = {
          app,
          pname ? "system-${app}",
          syspath ? "/usr/bin/${app}",
        }:
          final.runCommandLocal pname {} ''
            mkdir -p $out/bin
            ln -sT ${syspath} $out/bin/${app}
          '';
      };
      lib =
        {
          mkDefaultOverlayList = system:
            (self.lib.mkOverlayList system (attrValues overlayInputs))
            ++ [
              # mozilla.overlays.rust
              mozilla.overlays.firefox
            ];
          mkBaseModule = {
            system,
            profile ? {},
            impure ? false,
          }: {
            extraSpecialArgs = {
              inherit utils impure;
              profile =
                std.recursiveUpdate {
                  utility = false;
                  graphical = false;
                  extra = false;
                }
                profile;
              flakeInputs = inputs;
              resources = {
                pond = ./res/pond.png;
              };
            };
            modules =
              [
                # inputs.modloader64.homeManagerModules.default
                inputs.wired.homeManagerModules.default
                inputs.ash-scripts.homeManagerModules.default
                # inputs.wayland.homeManagerModules.default
                # inputs.zeal.homeManagerModules.default
              ]
              ++ (map (file: import file) (utils.listFiles ./mod));
          };
          mkNixOSModule = args @ {
            system,
            profile ? {},
            impure ? false,
          }: let
            base = self.lib.mkBaseModule args;
          in {
            imports = [home-manager.nixosModules.home-manager];
            config = {
              home-manager = {
                inherit (base) extraSpecialArgs;
                useGlobalPkgs = false;
                useUserPackages = true;
                sharedModules =
                  base.extraModules
                  ++ [
                    ({
                      config,
                      pkgs,
                      ...
                    }: {
                      home.stateVersion = stateVersion;
                      nixpkgs.overlays = self.lib.mkDefaultOverlayList system;
                    })
                  ];
                users."ash" = import ./cfg/home.nix;
              };
            };
          };
          mkHomeConfig = args @ {
            system,
            profile ? {},
            impure ? false,
          }: let
            base = self.lib.mkBaseModule args;
          in
            home-manager.lib.homeManagerConfiguration (base
              // {
                pkgs = nixpkgsFor.${system};
                modules =
                  base.modules
                  ++ [
                    {
                      home = {
                        inherit stateVersion;
                        username = "ash";
                        homeDirectory = "/home/ash";
                      };
                    }
                    (import ./cfg/home.nix)
                  ];
              });
        }
        // utils;
      homeConfigurations = genSystems (
        system: (
          mapHMConfigs (
            name: opts: self.lib.mkHomeConfig (opts // {inherit system;})
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
