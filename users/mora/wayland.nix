{ pkgs, ... }:

let
  niri' = pkgs.callPackage ./niri {};
  reset-brightness = pkgs.callPackage ./repo/reset-brightness.nix {};
  wl-gammarelay-rs = pkgs.callPackage ./repo/wl-gammarelay-rs.nix {};
  xwayland-satellite = pkgs.callPackage ./repo/xwayland-satellite.nix {};
in
{
  imports = [
    ./waybar
  ];

  ###
  ### NOTIFICATION DAEMON
  ###
  services.mako = {
    enable = true;
    anchor = "top-right";
    font = "monospace 8";
    format = "<small><b>%a</b> %s</small>\\n%b";
    margin = "5,10";
    padding = "0,5,5";

    extraConfig = ''
      [grouped]
      format=<small><b>(%g) %a</b> %s</small>\n%b

      [urgency=low]
      default-timeout=2000
      background-color=#222222FF
      border-color=#191919FF
      text-color=#888888FF

      [urgency=normal]
      default-timeout=5000
      ignore-timeout=1
      background-color=#225577FF
      border-color=#193F59FF
      text-color=#FFFFFFFF

      [urgency=critical]
      background-color=#900000FF
      border-color=#6C0000FF
      text-color=#FFFFFFFF

      [app-name="64Gram Desktop"]
      default-timeout=3000
      ignore-timeout=1

      [app-name="Spotify"]
      default-timeout=3000
      ignore-timeout=1
      background-color=#1ED760FF
      text-color=#000000FF
    '';
  };

  # systemd.user.services.mako = {
  #   Unit.PartOf = [ "graphical-session.target" ];
  #   Install.WantedBy = [ "graphical-session.target" ];
  #   Service = {
  #     ExecStart = "${pkgs.mako}/bin/mako";
  #     Restart = "on-failure";
  #   };
  # };

  ###
  ### PROGRAMS
  ###
  home.packages = with pkgs; [
    niri'

    wl-gammarelay-rs
    reset-brightness

    bemenu

    copyq
    xclip
    xwayland
    xwayland-satellite
    wl-clipboard
  ];

  programs = {
    foot.enable = true;
  };

  ###
  ### SERVICES
  ###
  systemd.user.services.wl-gammarelay-rs = {
    Unit.PartOf = [ "graphical-session.target" ];
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      ExecStart = "${wl-gammarelay-rs}/bin/wl-gammarelay-rs";
      Restart = "on-failure";
    };
  };

  systemd.user.services.xwayland-satellite = {
    Unit.PartOf = [ "graphical-session.target" ];
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      ExecStart = "${xwayland-satellite}/bin/xwayland-satellite";
      Restart = "on-failure";
    };
  };
}
