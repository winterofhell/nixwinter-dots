{ ... }:

{
  programs.plasma = {
    enable = true;
    overrideConfig = false;

    workspace = {
      enableMiddleClickPaste = false;
      tooltipDelay = 400;
      iconTheme = "Papirus-Dark";
      widgetStyle = "breeze";
      cursor = {
        theme = "catppuccin-mocha-mauve-cursors";
        size = 24;
        cursorFeedback = "None";
        taskManagerFeedback = false;
        animationTime = 1;
      };
    };


    hotkeys.commands = {
      launch-browser = {
        name = "Zen Browser";
        key = "Meta+W";
        command = "zen";
      };
      launch-files = {
        name = "Dolphin";
        key = "Meta+E";
        command = "dolphin";
      };
      launch-terminal = {
        name = "Kitty";
        key = "Meta+Return";
        command = "kitty";
      };
    };

    shortcuts = {
      kwin.Overview = [ ];
      ksmserver."Lock Session" = [
        "Meta+L"
        "Screensaver"
      ];
    };

    kwin = {
      edgeBarrier = 0;
      cornerBarrier = false;
    };

    configFile = {
      plasmarc.Theme.name = "breeze-dark";
      baloofilerc."Basic Settings"."Indexing-Enabled" = false;

      dolphinrc = {
        DetailsMode.PreviewSize = 32;
        General = {
          GlobalViewProps = false;
          ShowFullPath = true;
          ShowStatusBar = "FullWidth";
        };
        "KFileDialog Settings" = {
          "Places Icons Auto-resize" = false;
          "Places Icons Static Size" = 22;
        };
        MainWindow.MenuBar = "Disabled";
      };

      kdeglobals = {
        General = {
          ColorScheme = "CatppuccinMochaMauve";
          BrowserApplication = "zen-browser.desktop";
          TerminalApplication = "kitty";
          TerminalService = "kitty.desktop";
        };
        "KFileDialog Settings" = {
          "Automatically select filename extension" = true;
          "Breadcrumb Navigation" = true;
          "Show Inline Previews" = true;
          "Show Preview" = true;
          "Show hidden files" = false;
          "Sort directories first" = true;
          "View Style" = "Simple";
        };
      };

      kwinrc = {
        "org.kde.kdecoration2".theme = "__aurorae__svg__CatppuccinMocha-Modern";
        Windows = {
          BorderlessMaximizedWindows = false;
          ElectricBorderCooldown = 350;
          ElectricBorderDelay = 150;
          FocusPolicy = "ClickToFocus";
          RollOverDesktops = false;
        };
        Xwayland.Scale = 1;
      };
    };
  };
}
