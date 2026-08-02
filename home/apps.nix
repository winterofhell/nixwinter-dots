{
  pkgs,
  inputs,
  ...
}:

let
  system = pkgs.stdenv.hostPlatform.system;

  zen = inputs.zen-browser.packages.${system}.default.override {
    extraPolicies = {
      DisableAppUpdate = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      HardwareAcceleration = true;
      NoDefaultBookmarks = true;
      UserMessaging = {
        ExtensionRecommendations = false;
        FeatureRecommendations = false;
        FirefoxLabs = false;
        MoreFromMozilla = false;
        SkipOnboarding = true;
        UrlbarInterventions = false;
      };
      Preferences = {
        "browser.tabs.warnOnClose" = {
          Value = true;
          Status = "default";
        };
        "font.default.x-western" = {
          Value = "sans-serif";
          Status = "default";
        };
        "font.name.monospace.x-western" = {
          Value = "JetBrains Mono";
          Status = "default";
        };
        "font.name.sans-serif.x-western" = {
          Value = "JetBrains Mono";
          Status = "default";
        };
        "font.name.serif.x-western" = {
          Value = "JetBrains Mono";
          Status = "default";
        };
        "font.size.monospace.x-western" = {
          Value = 14;
          Status = "default";
          Type = "number";
        };
        "font.size.variable.x-western" = {
          Value = 16;
          Status = "default";
          Type = "number";
        };
        "widget.use-xdg-desktop-portal.file-picker" = {
          Value = 1;
          Status = "default";
          Type = "number";
        };
      };
    };
  };
in
{
  home.packages = with pkgs; [
    zen
    vesktop
    fd
    jq
    lsof
    nh
    nix-output-monitor
    nvd
    ripgrep
  ];

  xdg.desktopEntries.zen-browser = {
    name = "Zen Browser";
    genericName = "Web Browser";
    exec = "zen %U";
    icon = "zen";
    terminal = false;
    noDisplay = true;
    categories = [
      "Network"
      "WebBrowser"
    ];
    mimeType = [
      "application/json"
      "application/xhtml+xml"
      "text/html"
      "text/xml"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
    ];
  };

  xdg.mimeApps.defaultApplications = {
    "application/json" = [ "zen-browser.desktop" ];
    "application/pdf" = [ "zen-browser.desktop" ];
    "application/vnd.rar" = [ "org.kde.ark.desktop" ];
    "application/x-7z-compressed" = [ "org.kde.ark.desktop" ];
    "application/x-bzip2" = [ "org.kde.ark.desktop" ];
    "application/x-compressed-tar" = [ "org.kde.ark.desktop" ];
    "application/x-gzip" = [ "org.kde.ark.desktop" ];
    "application/x-rar" = [ "org.kde.ark.desktop" ];
    "application/x-tar" = [ "org.kde.ark.desktop" ];
    "application/x-xz" = [ "org.kde.ark.desktop" ];
    "application/zip" = [ "org.kde.ark.desktop" ];
    "application/xhtml+xml" = [ "zen-browser.desktop" ];
    "text/html" = [ "zen-browser.desktop" ];
    "x-scheme-handler/http" = [ "zen-browser.desktop" ];
    "x-scheme-handler/https" = [ "zen-browser.desktop" ];
  };

  programs = {
    btop.enable = true;

    gh = {
      enable = true;
      settings = {
        git_protocol = "https";
        prompt = "enabled";
      };
    };

    git = {
      enable = true;
      settings = {
        init.defaultBranch = "main";
        fetch.prune = true;
        pull.ff = "only";
        rerere.enabled = true;
      };
    };

    vscode = {
      enable = true;
      package = pkgs.vscode;
    };
  };
}
