{ config, pkgs, ... }:

{
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;

    settings = {
      clock = true;
      daemonize = true;
      effect-blur = "3x2"; # 5x3
      effect-vignette = "0.15:0.75";
      fade-in = 0.3;
      font-size = 28;
      grace = 5;
      image = "${config.home.homeDirectory}/.wallpaper";
      indicator = true;
      indicator-radius = 100;
      indicator-thickness = 8;
      inside-color = "0b132bdd";
      ring-color = "7f3ea3";
      show-failed-attempts = true;
      text-color = "ffffff";
      timestr = "%I:%M:%S %p";
    };
  };

  services.swayidle = {
    enable = true;
    systemdTarget = "hyprland-session.target";

    timeouts = [
      {
        timeout = 300;
        command = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
        resumeCommand = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
      }
    ];
  };
}
