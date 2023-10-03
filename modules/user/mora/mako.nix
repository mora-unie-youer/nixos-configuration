{ pkgs, ... }:

{
  services.mako = {
    enable = true;
    # anchor = "bottom-right";
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

      [app-name="Kotatogram Desktop"]
      default-timeout=3000
      ignore-timeout=1

      [app-name="64Gram Desktop"]
      default-timeout=3000
      ignore-timeout=1

      [app-name="Spotify"]
      default-timeout=3000
      ignore-timeout=1
      background-color=#1ED760FF
      # background-color=#169C46FF
      text-color=#000000FF
    '';
  };

  systemd.user.services.mako = {
    Unit.PartOf = [ "graphical-session.target" ];
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      ExecStart = "${pkgs.mako}/bin/mako";
      Restart = "on-failure";
    };
  };
}
