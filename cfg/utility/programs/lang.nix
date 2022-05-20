{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # nix
    statix
    alejandra
    rnix-lsp
    # zig
    zig
    zls
    # rust
    latest.rustChannels.nightly.rust
  ];
}
