{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wineWow64Packages.stagingFull
    winetricks
  ];

  environment.etc."vkBasalt/vkBasalt.conf".text = ''
    effects = cas
    casSharpness = 0.30
  '';
}
