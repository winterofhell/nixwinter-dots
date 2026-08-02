{ pkgs, ... }:

{
  home.packages = [ pkgs.fastfetch ];

  xdg.configFile."fastfetch/config.jsonc".source = ./fastfetch/config.jsonc;
  xdg.configFile."fastfetch/nixos.txt".source = ./fastfetch/nixos.txt;
}
