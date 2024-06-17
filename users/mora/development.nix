{ config, pkgs, ... }:

{
  home.sessionPath = [
    (config.home.homeDirectory + "/.local/share/JetBrains/Toolbox/scripts")
  ];

  home.packages = with pkgs; [
    jetbrains-toolbox
  ];
}
