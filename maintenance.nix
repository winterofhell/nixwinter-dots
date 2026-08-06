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

  system.tools = {
    nixos-build-vms.enable = false;
    nixos-generate-config.enable = false;
    nixos-install.enable = false;
  };

  documentation = {
    nixos.enable = false;
    info.enable = false;
    doc.enable = false;
  };
}
