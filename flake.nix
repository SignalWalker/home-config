{
  description = "Ash Walker's Home Manager config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # apps
    ## neovim
    # neovim = {
    #   url = github:neovim/neovim?dir=contrib;
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # nixvim = {
    #   url = github:pta2002/nixvim;
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = inputs@{ home-manager, ... }:
    let
      system = "x86_64-linux";
      username = "ash";
    in
    {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        # Specify the path to your home configuration here
        configuration = import ./home.nix;

        inherit system username;
        homeDirectory = "/home/${username}";
        # Update the state version as needed.
        # See the changelog here:
        # https://nix-community.github.io/home-manager/release-notes.html#sec-release-21.05
        stateVersion = "21.11";

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = { inherit (inputs) neovim nixvim; };
      };
    };
}
