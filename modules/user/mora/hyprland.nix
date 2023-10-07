{ pkgs, hyprsome, ... }:

let
  hyprsome' = hyprsome.packages.${pkgs.system}.default;
in
{
  config = {
    # Adding some Hyprland "plugins"
    home.packages = with pkgs; [ hyprpicker hyprsome' ];

    # Configuring Hyprland
    wayland.windowManager.hyprland = {
      enable = true;
      enableNvidiaPatches = true;

      extraConfig = ''
        # Environment variables
        ## Input Method
        env = GLFW_IM_MODULE,fcitx
        env = GTK_IM_MODULE,fcitx
        env = INPUT_METHOD,fcitx
        env = QT_IM_MODULE,fcitx
        env = XMODIFIERS,@im=fcitx
        env = XIM_SERVERS,fcitx
        ## Wayland backends
        env = CLUTTER_BACKEND,wayland
        env = GDK_BACKEND,wayland,x11
        env = GLFW_BACKEND,wayland
        env = MOZ_ENABLE_WAYLAND,1
        env = QT_QPA_PLATFORM,wayland-egl;xcb
        env = SDL_VIDEODRIVER,wayland
        ## Wayland properties
        ### GTK
        #env = GDK_DPI_SCALE,1
        ### Qt
        #env = QT_AUTO_SCREEN_SCALE_FACTOR,1
        #env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1

        # Monitors
        monitor=DP-5, 1920x1080, 0x0, 1
        monitor=eDP-1, 1920x1080, 1920x0, 1

        # Workspaces bound to monitors
        workspace=1, monitor:eDP-1
        workspace=2, monitor:eDP-1
        workspace=3, monitor:eDP-1
        workspace=4, monitor:eDP-1
        workspace=5, monitor:eDP-1
        workspace=6, monitor:eDP-1
        workspace=7, monitor:eDP-1
        workspace=8, monitor:eDP-1
        workspace=9, monitor:eDP-1

        workspace=11, monitor:DP-5
        workspace=12, monitor:DP-5
        workspace=13, monitor:DP-5
        workspace=14, monitor:DP-5
        workspace=15, monitor:DP-5
        workspace=16, monitor:DP-5
        workspace=17, monitor:DP-5
        workspace=18, monitor:DP-5
        workspace=19, monitor:DP-5

        # General settings
        general {
          gaps_in = 2
          gaps_out = 5
        }

        # Input
        input {
          # kb_layout = us,ru
          # kb_options = grp:win_space_toggle

          repeat_delay = 250
          repeat_rate = 50
        }

        # Touchpad
        device:synps/2-synaptics-touchpad {
          sensitivity = 0.6
        }

        # Gestures
        gestures {
          # workspace_swipe = true
        }

        # Dwindle layout
        dwindle {
          no_gaps_when_only = true
          preserve_split = true
        }

        # Animations
        animations {
          animation = windows, 1, 1, default, popin 90%
          animation = workspaces, 1, 2, default, slide
        }

        # Misc
        misc {
          key_press_enables_dpms = true
          mouse_move_enables_dpms = true
        }

        # Keybindings
        $mainMod = SUPER

        ## General
        bind = $mainMod SHIFT, Q, killactive,
        bind = $mainMod SHIFT, E, exit,

        ## System controls
        bindle = , XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+
        bindle = , XF86AudioLowerVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%-
        bindle = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        bindle = , XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
        bindle = , XF86MonBrightnessDown, exec, brightnessctl set 5%-
        bindle = , XF86MonBrightnessUp, exec, brightnessctl set 5%+
        bindle = SHIFT, XF86MonBrightnessDown, exec, brightnessctl set 1%-
        bindle = SHIFT, XF86MonBrightnessUp, exec, brightnessctl set 1%+

        ## Applications
        # bind = $mainMod, Space, exec, true # Fix for Helix
        bind = $mainMod, Return, exec, foot
        bind = $mainMod, D, exec, bemenu-run -b --tf '##18b218' --hf '##3daee9' --sf '##3daee9' --scf '##3daee9'

        ## Workspaces
        bind = $mainMod, 1, exec, hyprsome workspace 1
        bind = $mainMod, 2, exec, hyprsome workspace 2
        bind = $mainMod, 3, exec, hyprsome workspace 3
        bind = $mainMod, 4, exec, hyprsome workspace 4
        bind = $mainMod, 5, exec, hyprsome workspace 5
        bind = $mainMod, 6, exec, hyprsome workspace 6
        bind = $mainMod, 7, exec, hyprsome workspace 7
        bind = $mainMod, 8, exec, hyprsome workspace 8
        bind = $mainMod, 9, exec, hyprsome workspace 9
        bind = $mainMod SHIFT, 1, exec, hyprsome move 1
        bind = $mainMod SHIFT, 2, exec, hyprsome move 2
        bind = $mainMod SHIFT, 3, exec, hyprsome move 3
        bind = $mainMod SHIFT, 4, exec, hyprsome move 4
        bind = $mainMod SHIFT, 5, exec, hyprsome move 5
        bind = $mainMod SHIFT, 6, exec, hyprsome move 6
        bind = $mainMod SHIFT, 7, exec, hyprsome move 7
        bind = $mainMod SHIFT, 8, exec, hyprsome move 8
        bind = $mainMod SHIFT, 9, exec, hyprsome move 9

        ## Windows
        bind = $mainMod, Minus, togglespecialworkspace,
        bind = $mainMod SHIFT, Minus, movetoworkspace, special
        bind = $mainMod SHIFT, Space, togglefloating,
        bind = $mainMod, F, fullscreen
        bind = $mainMod, R, togglesplit
        bindm = $mainMod, mouse:272, movewindow
        bindm = $mainMod, mouse:273, resizewindow

        #bind = $mainMod, h, exec, hyprsome focus l
        #bind = $mainMod, j, exec, hyprsome focus d
        #bind = $mainMod, k, exec, hyprsome focus u
        #bind = $mainMod, l, exec, hyprsome focus r
        bind = $mainMod, h, movefocus, l
        bind = $mainMod, j, movefocus, d
        bind = $mainMod, k, movefocus, u
        bind = $mainMod, l, movefocus, r

        ## Screenshoting
        bind = , Print, exec, screenshot -c current-monitor
        bind = SHIFT, Print, exec, screenshot -c current-window
        bind = $mainMod, Print, exec, screenshot -c monitor
        bind = $mainMod SHIFT, Print, exec, screenshot -c window
        bind = CONTROL SHIFT, Print, exec, screenshot -c region

        # Window rules
        # windowrule = pseudo,fcitx

        # Autostart
        exec-once = waybar
        exec-once = copyq --start-server
        exec-once = ${pkgs.hyprpaper}/bin/hyprpaper
        exec-once = fcitx5 -d -r
      '';
    };
  };
}
