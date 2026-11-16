{ pkgs, ... }:

{
  home.packages = with pkgs; [
    dotnet-sdk_8
    nodejs_latest
    typescript-language-server
    firefox
    chromium
    cargo
    rustc
    direnv
    nix-direnv

    # tools and game assets
    ast-grep shellcheck difftastic hyperfine
    ffmpeg sox imagemagick oxipng pngquant
  ];

  home.sessionVariables = {
    DOTNET_CLI_TELEMETRY_OPTOUT = "1";
    DOTNET_NOLOGO = "1";
    NPM_CONFIG_PREFIX = "$HOME/.npm-global";
  };
  home.sessionPath = [ "$HOME/.npm-global/bin" ];
}
