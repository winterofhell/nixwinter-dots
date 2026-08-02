{ ... }:

{
  programs.nh = {
    enable = true;
    flake = "/etc/nixos";
    clean = {
      enable = true;
      dates = "daily";
      extraArgs = "--keep 3";
    };
  };

  services.flatpak.enable = true;
  xdg.portal.enable = true;
}
