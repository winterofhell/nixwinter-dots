{ pkgs, ... }:

{
  home.packages = with pkgs; [
    dotnet-sdk_8
  ];

  home.sessionVariables = {
    DOTNET_CLI_TELEMETRY_OPTOUT = "1";
    DOTNET_NOLOGO = "1";
  };
}