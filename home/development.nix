{ pkgs, ... }:

{
  home.packages = with pkgs; [
    dotnet-sdk_8
    nodejs
  ];

  home.sessionVariables = {
    DOTNET_CLI_TELEMETRY_OPTOUT = "1";
    DOTNET_NOLOGO = "1";
    NPM_CONFIG_PREFIX = "$HOME/.npm-global";
  };
  home.sessionPath = [ "$HOME/.npm-global/bin" ];
}