{ pkgs, ... }:

let
  catppuccinKde = pkgs.catppuccin-kde.override {
    flavour = [ "mocha" ];
    accents = [ "mauve" ];
    winDecStyles = [ "modern" ];
  };

  catppuccinSddm = pkgs.catppuccin-sddm.override {
    flavor = "mocha";
    accent = "mauve";
    font = "JetBrains Mono";
    fontSize = "10";
    clockEnabled = true;
  };

  catppuccinPapirus = pkgs.catppuccin-papirus-folders.override {
    flavor = "mocha";
    accent = "mauve";
  };
in
{
  fonts = {
    packages = with pkgs; [
      jetbrains-mono
      nerd-fonts.jetbrains-mono
      liberation_ttf
      noto-fonts
      noto-fonts-color-emoji
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [
          "JetBrains Mono"
          "Noto Sans Mono"
          "Noto Color Emoji"
        ];
        sansSerif = [
          "JetBrains Mono"
          "Noto Sans"
          "Noto Color Emoji"
        ];
        serif = [
          "JetBrains Mono"
          "Noto Serif"
          "Noto Color Emoji"
        ];
        emoji = [
          "Noto Color Emoji"
        ];
      };
    };
  };

  environment.systemPackages = [
    catppuccinKde
    catppuccinSddm
    catppuccinPapirus
    pkgs.catppuccin-cursors.mochaMauve
    pkgs.papirus-icon-theme
    pkgs.kdePackages.ark
    pkgs.unrar
  ];

  services.displayManager.sddm = {
    theme = "catppuccin-mocha-mauve";
    settings.Theme = {
      CursorTheme = "catppuccin-mocha-mauve-cursors";
      CursorSize = 24;
    };
  };
}
