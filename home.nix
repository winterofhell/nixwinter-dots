{ pkgs, ... }:

let
  gtkTheme = pkgs.catppuccin-gtk.override {
    accents = [ "mauve" ];
    size = "standard";
    tweaks = [ ];
    variant = "mocha";
  };
in
{
  imports = [
    ./home/apps.nix
    ./home/flatpak.nix
    ./home/fish.nix
    ./home/fastfetch.nix
    ./home/kitty.nix
    ./home/plasma.nix
  ];

  home = {
    username = "nixwinter";
    homeDirectory = "/home/nixwinter";
    stateVersion = "26.05";
    sessionVariables = {
      BROWSER = "zen";
      TERMINAL = "kitty";
      EDITOR = "code --wait";
      VISUAL = "code --wait";
      PAGER = "less";
      LESS = "-R --mouse";
      NH_FLAKE = "/etc/nixos";
      MOZ_ENABLE_WAYLAND = "1";
    };
    pointerCursor = {
      enable = true;
      size = 24;
      gtk.enable = true;
      x11.enable = true;
    };
  };

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
    mimeApps.enable = true;
  };

  catppuccin = {
    autoEnable = true;
    enable = true;
    flavor = "mocha";
    accent = "mauve";
    cursors.enable = true;
    gtk.icon.enable = true;
    vscode.profiles.default = {
      enable = true;
      icons.enable = true;
    };
  };

  gtk = {
    enable = true;
    font = {
      name = "JetBrains Mono";
      size = 11;
    };
    theme = {
      name = "catppuccin-mocha-mauve-standard";
      package = gtkTheme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-button-images = true;
      gtk-cursor-theme-name = "catppuccin-mocha-mauve-cursors";
      gtk-cursor-theme-size = 24;
      gtk-decoration-layout = "menu:minimize,maximize,close";
      gtk-enable-animations = true;
      gtk-font-name = "JetBrains Mono 11";
      gtk-menu-images = true;
      gtk-primary-button-warps-slider = false;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-cursor-theme-name = "catppuccin-mocha-mauve-cursors";
      gtk-cursor-theme-size = 24;
      gtk-decoration-layout = "menu:minimize,maximize,close";
      gtk-enable-animations = true;
      gtk-font-name = "JetBrains Mono 11";
    };
  };

  programs.home-manager.enable = true;
}
