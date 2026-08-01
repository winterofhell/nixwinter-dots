{ ... }:

{
  programs = {
    bat = {
      enable = true;
      config = {
        paging = "never";
        style = "numbers,changes,header";
      };
    };

    eza = {
      enable = true;
      enableFishIntegration = true;
      git = true;
      icons = "auto";
      colors = "auto";
    };

    fish = {
      enable = true;
      preferAbbrs = true;

      interactiveShellInit = ''
        set -g fish_greeting
        bind ctrl-backspace backward-kill-word
        bind ctrl-delete kill-word
        bind \cw backward-kill-word
      '';

      shellAbbrs = {
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        c = "clear";
        config = "cd ~/.config";
        desktop = "cd ~/Desktop";
        downloads = "cd ~/Downloads";
        dots = "cd ~/nixwinter-dots";
        failed = "systemctl --failed";
        fm = "dolphin .";
        g = "git";
        ga = "git add";
        gaa = "git add --all";
        gb = "git branch";
        gc = "git commit";
        gcm = "git commit -m";
        gd = "git diff";
        gds = "git diff --staged";
        gl = "git log --oneline --graph --decorate --all";
        gp = "git push";
        gpl = "git pull --ff-only";
        gs = "git status";
        gsc = "git switch -c";
        gst = "git stash";
        gsta = "git stash apply";
        gsw = "git switch";
        ipinfo = "ip -brief address";
        journal = "journalctl -b -p warning --no-pager";
        kernel = "uname -a";
        ll = "eza -lah --icons=auto --group-directories-first --git";
        lt = "eza --tree --level=2 --icons=auto --group-directories-first";
        lta = "eza --tree --level=3 --icons=auto --group-directories-first --all";
        mounts = "findmnt";
        nfu = "sudo nix flake update --flake /etc/nixos";
        ngc = "sudo nix-collect-garbage --delete-older-than 14d";
        nrb = "nh os boot /etc/nixos";
        nrd = "sudo nixos-rebuild dry-build --flake /etc/nixos#nixos --accept-flake-config";
        nrs = "nh os switch /etc/nixos";
        nrt = "nh os test /etc/nixos";
        open = "xdg-open";
        ports = "ss -tulpn";
        services = "systemctl --type=service --state=running";
        temps = "sensors";
        userlog = "journalctl --user -b -p warning --no-pager";
        wifi = "nmtui";
        wifi-list = "nmcli device wifi list";
        wifi-rescan = "nmcli device wifi rescan";
      };

      functions = {
        archive = ''
          if test (count $argv) -lt 2
            echo "Использование: archive output.tar.zst <файлы/папки>"
            return 1
          end
          set -l output $argv[1]
          set -e argv[1]
          tar --zstd -cvf "$output" $argv
        '';

        backup = ''
          if test (count $argv) -ne 1
            echo "Использование: backup <файл или папка>"
            return 1
          end
          cp -a -- "$argv[1]" "$argv[1].bak-"(date +%Y-%m-%d_%H-%M-%S)
        '';

        cdf = ''
          set -l target (fd --type d --hidden --exclude .git . | fzf)
          test -n "$target"; and cd "$target"
        '';

        clear = ''
          printf '\033[2J\033[3J\033[1;1H'
        '';

        extract = ''
          if test (count $argv) -ne 1
            echo "Использование: extract <архив>"
            return 1
          end
          set -l file $argv[1]
          if not test -f "$file"
            echo "Файл не найден: $file"
            return 1
          end
          switch "$file"
            case '*.tar.bz2' '*.tbz2'
              tar xjf "$file"
            case '*.tar.gz' '*.tgz'
              tar xzf "$file"
            case '*.tar.xz' '*.txz'
              tar xJf "$file"
            case '*.tar.zst'
              tar --zstd -xf "$file"
            case '*.tar'
              tar xf "$file"
            case '*.zip'
              unzip "$file"
            case '*.rar'
              unrar x "$file"
            case '*.7z'
              7z x "$file"
            case '*.gz'
              gunzip "$file"
            case '*.bz2'
              bunzip2 "$file"
            case '*.xz'
              unxz "$file"
            case '*'
              echo "Неизвестный формат архива: $file"
              return 1
          end
        '';

        mkcd = ''
          if test (count $argv) -ne 1
            echo "Использование: mkcd <папка>"
            return 1
          end
          mkdir -p -- "$argv[1]"; and cd -- "$argv[1]"
        '';

        ndiff = ''
          set -l result (nix build /etc/nixos#nixosConfigurations.nixos.config.system.build.toplevel --no-link --print-out-paths)
          or return
          nvd diff /run/current-system "$result"
        '';

        showpath = ''
          string split : $PATH
        '';

        ssh = ''
          if test "$TERM" = "xterm-kitty"
            kitten ssh $argv
          else
            command ssh $argv
          end
        '';

        sysinfo = ''
          echo "System"
          uname -a
          echo
          echo "Uptime"
          uptime
          echo
          echo "Memory"
          free -h
          echo
          echo "Disks"
          lsblk -o NAME,SIZE,FSTYPE,FSVER,MOUNTPOINTS,MODEL
        '';

        timer = ''
          if test (count $argv) -eq 0
            echo "Использование: timer <команда>"
            return 1
          end
          set -l start (date +%s)
          command $argv
          set -l result $status
          set -l finish (date +%s)
          echo
          echo "Время: "(math $finish - $start)" сек."
          return $result
        '';
      };
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
      defaultCommand = "fd --type f --hidden --follow --exclude .git";
      fileWidget.command = "fd --type f --hidden --follow --exclude .git";
      changeDirWidget.command = "fd --type d --hidden --follow --exclude .git";
    };

    starship = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        add_newline = false;
        format = "$directory$git_branch$git_status$fill$cmd_duration$line_break$character";
        right_format = "$status";

        character = {
          success_symbol = "[❯](bold green)";
          error_symbol = "[❯](bold red)";
          vimcmd_symbol = "[❮](bold lavender)";
        };

        cmd_duration = {
          min_time = 2000;
          format = "[$duration]($style)";
          style = "yellow";
        };

        directory = {
          style = "bold lavender";
          truncation_length = 4;
          truncate_to_repo = false;
          read_only = " ";
        };

        fill.symbol = " ";

        git_branch = {
          symbol = " ";
          style = "bold mauve";
          format = "[$symbol$branch]($style) ";
        };

        git_status = {
          style = "peach";
          format = "[$all_status$ahead_behind]($style) ";
        };

        hostname = {
          ssh_only = true;
          format = "[$hostname]($style) ";
          style = "bold blue";
        };

        nix_shell = {
          symbol = " ";
          format = "[$symbol$name]($style) ";
          style = "bold sapphire";
        };

        package.disabled = true;

        status = {
          disabled = false;
          format = "[$status]($style)";
          style = "bold red";
        };

        username.show_always = false;
      };
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
