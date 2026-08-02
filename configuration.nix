{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./storage.nix
  ];

  nixpkgs.overlays = [
    inputs.nix-cachyos-kernel.overlays.pinned
  ];

  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      warn-dirty = false;
      max-jobs = "auto";
      cores = 0;
      builders-use-substitutes = true;
      trusted-users = [ "root" "@wheel" ];

      extra-substituters = [
        "https://attic.xuyh0120.win/lantian"
      ];
      extra-trusted-public-keys = [
        "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
      ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 10;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 3;


  boot.blacklistedKernelModules = [
    "bluetooth"
    "btusb"
  ];

  boot.kernelPackages =
    pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-zen4;

  boot.supportedFilesystems = [ "xfs" ];
  boot.initrd.systemd.enable = true;
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [
    "ntsync"
    "tcp_bbr"
  ];

  boot.kernelParams = [
    "amd_pstate=active"
    "transparent_hugepage=madvise"
    "nmi_watchdog=0"
    "split_lock_detect=off"
    "nowatchdog"
    "zswap.enabled=0"
    "pci=pcie_bus_perf"
    "pcie_aspm.policy=performance"
    "usbcore.autosuspend=-1"
    "page_alloc.shuffle=1"
  ];

  boot.kernel.sysctl = {
    "vm.swappiness" = 150;
    "vm.vfs_cache_pressure" = 50;
    "vm.page-cluster" = 0;
    "vm.dirty_bytes" = 268435456;
    "vm.dirty_background_bytes" = 67108864;
    "vm.dirty_writeback_centisecs" = 1500;
    "vm.max_map_count" = 2147483642;

    "kernel.nmi_watchdog" = 0;
    "kernel.sched_autogroup_enabled" = 1;
    "kernel.kptr_restrict" = 2;

    "fs.file-max" = 2097152;
    "fs.inotify.max_user_watches" = 1048576;
    "fs.inotify.max_user_instances" = 8192;

    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.core.netdev_max_backlog" = 4096;
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 25;
    priority = 100;
  };

  fileSystems."/".options = lib.mkAfter [ "noatime" "lazytime" ];
  services.fstrim.enable = true;

  services.udev.extraRules = ''
    ACTION=="add|change", KERNEL=="sd[a-z]*", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
    ACTION=="add|change", KERNEL=="sd[a-z]*|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="mq-deadline"
    ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="none"
  '';

  systemd.tmpfiles.rules = [
    "w /sys/kernel/mm/transparent_hugepage/defrag - - - - defer+madvise"
  ];

  services.irqbalance.enable = false;

  services.scx-loader = {
    enable = true;
    schedsPackages = [ pkgs.scx.rustscheds ];
    config = {
      default_sched = "scx_lavd";
      default_mode = "Gaming";
    };
  };

  specialisation."cachyos-no-scx".configuration = {
    services.scx-loader.enable = lib.mkForce false;
  };

  specialisation."stock-kernel".configuration = {
    boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
    services.scx-loader.enable = lib.mkForce false;
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    networkmanager.wifi.powersave = false;
    modemmanager.enable = false;
    firewall.enable = true;
  };

  services.resolved.enable = true;
  networking.networkmanager.dns = "systemd-resolved";

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  services.xserver = {
    enable = true;
    excludePackages = [ pkgs.xterm ];
    videoDrivers = [ "amdgpu" ];
    xkb = {
      layout = "us,ru";
      variant = "";
    };
  };
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.desktopManager.plasma6.enable = true;

  environment.etc."xdg/baloofilerc".text = ''
    [Basic Settings]
    Indexing-Enabled=false
  '';

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    bluedevil
    plasma-browser-integration
    plasma-workspace-wallpapers
    konsole
    kwin-x11
    elisa
    okular
    kate
    ktexteditor
    khelpcenter
    baloo-widgets
    dolphin-plugins
    krdp
    plasma-keyboard
    qtvirtualkeyboard
    union
    qrca
    discover
  ];

  programs.kde-pim.enable = false;
  services.orca.enable = false;
  services.geoclue2.enable = false;
  services.printing.enable = false;

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;

  hardware.amdgpu = {
    initrd.enable = true;
    overdrive.enable = true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.bluetooth = {
    enable = false;
    powerOnBoot = false;
  };

  services.blueman.enable = false;

  services.lact.enable = true;

  programs.steam = {
    enable = true;
    protontricks.enable = true;

    extraPackages = with pkgs; [
      gamemode
      gamescope
      mangohud
      vkbasalt
    ];
  };

  programs.gamescope = {
    enable = true;
    enableWsi = true;
    capSysNice = true;
  };

  programs.fish = {
    enable = true;
  };

  programs.gamemode = {
    enable = true;
    enableRenice = true;

    settings = {
      general = {
        renice = 10;
        desiredgov = "performance";
        softrealtime = "off";
        igpu_power_threshold = -1;
        inhibit_screensaver = 1;
        ioprio = 0;
      };
    };
  };

  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    extraConfig.pipewire."92-low-latency" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.allowed-rates" = [ 48000 ];
        "default.clock.quantum" = 256;
        "default.clock.min-quantum" = 64;
        "default.clock.max-quantum" = 1024;
      };
    };
  };

  security.pam.loginLimits = [
    {
      domain = "@audio";
      type = "-";
      item = "rtprio";
      value = "99";
    }
  ];
  systemd.settings.Manager.DefaultLimitNOFILE = "2048:2097152";
  systemd.user.settings.Manager = {
    DefaultLimitNOFILE = 1048576;
  };

  services.journald.extraConfig = ''
    SystemMaxUse=100M
    RuntimeMaxUse=50M
    MaxRetentionSec=7day
  '';

  services.fwupd.enable = true;
  programs.firefox = {
    enable = true;
    policies = {
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
    };
    nativeMessagingHosts.packages = lib.mkForce [ ];
  };
  programs.chromium.enablePlasmaBrowserIntegration = lib.mkForce false;

  users.users.nixwinter = {
    isNormalUser = true;
    description = "nixwinter";
    shell = pkgs.fish;
    extraGroups = [
      "audio"
      "gamemode"
      "input"
      "networkmanager"
      "video"
      "wheel"
    ];
  };

  fonts.packages = with pkgs; [
    liberation_ttf
    noto-fonts
    noto-fonts-color-emoji
  ];

  xdg.terminal-exec = {
    enable = true;
    settings.default = [ "kitty.desktop" ];
  };

  environment.sessionVariables = {
    DO_NOT_TRACK = "1";
    GH_TELEMETRY = "false";
  };

  environment.systemPackages = with pkgs; [
    # diagnostics and monitoring
    btop
    lm_sensors
    pciutils
    usbutils

    # graphics/vulkan diagnostics
    libva-utils
    mesa-demos
    vulkan-tools

    # gaming
    mangohud
    protonplus
    vkbasalt

    # general
    (callPackage ./mini-eq.nix { })
    curl
    gh
    git
    kde-rounded-corners
    plasma-panel-colorizer
    p7zip
    unzip
    wget
    xfsprogs
    vscode
  ];

  system.stateVersion = "26.05";
}
