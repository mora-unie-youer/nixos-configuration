{ pkgs, ... }:

let
  workspaces = pkgs.writeShellScriptBin "niri-workspaces" ''
    monitor=$1
    nu -c "niri msg -j workspaces | from json | where output == '$monitor' | each { |ws| if \$ws.is_active { '<b>' + \$'(\$ws.idx)' + '</b>' } else { \$ws.idx } } | str join ' '"
  '';
in
{
  programs.waybar = {
    enable = true;
    style = ./style.css;
    settings = {
      mainBar = {
        height = 20;
        layer = "top";
        spacing = 0;

        modules-left = [
          "custom/workspaces"
          "sway/scratchpad"
          "sway/mode"
        ];

        modules-center = [];

        modules-right = [
          "idle_inhibitor"
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          "temperature"
          "backlight"
          "battery"
          "bluetooth"
          "sway/language"
          "clock"
          "tray"
        ];


        backlight = {
          format = "{percent}% {icon}";
          format-icons = [ "" "" "" "" "" "" "" "" "" ];
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
          format-icons = ["" "" "" "" ""];
        };

        clock = {
          timezones = [ "UTC" "Europe/Moscow" ];
          tooltip-format = "<big>{:%Y %B %d}</big>\n<tt><small>{calendar}</small></tt>";
          interval = 1;
          format = "{:%I:%M:%S %p %Z}";
          format-alt = "{:%Y-%m-%d}";

          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };

          actions = {
            on-click-middle = "tz_up";
            on-click-right = "mode";
            on-scroll-up = "tz_up";
            on-scroll-down = "tz_down";
          };
        };

        cpu = {
          format = "{usage}% ";
          tooltip = false;
        };

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };

        memory = {
          format = "{used:0.1f}/{total:0.1f} GiB ";
        };

        network = {
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "{ipaddr}/{cidr} ";
          tooltip-format = "{ifname} via {gwaddr} ";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };

        pulseaudio = {
          scroll-step = 5;
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";

          ignored-sinks = [ "Easy Effects Sink" ];
        };

        temperature = {
          hwmon-path-abs = "/sys/devices/platform/coretemp.0/hwmon";
          input-filename = "temp1_input";
          critical-threshold = 80;
          format = "{temperatureC}°C"; 
        };

        tray = {
          spacing = 10;
        };

        "custom/workspaces" = {
          exec = "${workspaces}/bin/niri-workspaces $WAYBAR_OUTPUT_NAME";
          signal = 8;
        };
      };
    };
  };

  systemd.user.services.waybar = {
    Unit.PartOf = [ "graphical-session.target" ];
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      ExecStart = "${pkgs.waybar}/bin/waybar";
      Restart = "on-failure";
    };
  };
}
