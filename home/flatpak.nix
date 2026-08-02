{ pkgs, ... }:

{
  systemd.user.services.flatpak-maintenance = {
    Unit.Description = "Flatpak maintenance";
    Service = {
      Type = "oneshot";
      ExecStart = "-${pkgs.flatpak}/bin/flatpak update --user --noninteractive -y";
      ExecStartPost = "-${pkgs.flatpak}/bin/flatpak uninstall --user --unused --noninteractive -y";
    };
  };

  systemd.user.timers.flatpak-maintenance = {
    Unit.Description = "Weekly Flatpak maintenance";
    Timer = {
      OnCalendar = "weekly";
      Persistent = true;
      RandomizedDelaySec = "30m";
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
