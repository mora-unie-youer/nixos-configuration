{ pkgs, ... }:

{
  # Configuring "mora" user software
  config = {
    # "Local" packages
    home.packages = with pkgs; [
      # Required packages for other packages
      gcr

      # Shell utilities
      ffmpeg-full
      jq
      (pkgs.callPackage ./scripts/screenshot.nix {})

      # GUI utilities
      bemenu
      copyq
      (discord-canary.override { withOpenASAR = true; })

      (pkgs.callPackage ./programs/64gram-desktop-bin.nix {})
      (pkgs.callPackage ./programs/spotify {})

      # Steam
      steam
      steam.run

      # Wine
      wineWowPackages.waylandFull
      wineasio
      winetricks
      bottles
    ];

    # Configuring programs
    programs = {
      # Configuring foot terminal
      foot.enable = true;

      # Configuring GnuPG
      gpg = {
        enable = true;

        settings = {
          ask-cert-level = true;
          expert = true;

          list-options = [ "show-sig-expire" "show-uid-validity" "show-unusable-subkeys" "show-unusable-uids"];
          verify-options = [ "show-uid-validity" "show-unusable-uids" ];

          # with-fingerprint twice
          with-fingerprint = [ "" "" ];
          with-keygrip = true;
        };
      };

      # Configuring tmux
      tmux = {
        enable = true;
        tmuxinator.enable = true;
        tmuxp.enable = true;

        disableConfirmationPrompt = true;
        escapeTime = 0;
        mouse = true;
        historyLimit = 10000;
        terminal = "tmux-256color";

        sensibleOnTop = false;
        plugins = with pkgs.tmuxPlugins; [
          battery
          better-mouse-mode
          cpu

          copycat
          extrakto
          jump
          yank

          {
            plugin = resurrect;
            extraConfig = '''';
          }

          {
            plugin = continuum;
            extraConfig = '''';
          }

          {
            plugin = catppuccin;
            extraConfig = "set -g @catppuccin_flavour 'mocha'";
          }
        ];

        extraConfig = ''
          bind-key -n M-k select-pane -U
          bind-key -n M-Up select-pane -U
          bind-key -n M-j select-pane -D
          bind-key -n M-Down select-pane -D
          bind-key -n M-h select-pane -L
          bind-key -n M-Left select-pane -L
          bind-key -n M-l select-pane -R
          bind-key -n M-Right select-pane -R
        '';
      };
    };

    # Configuring services
    services = {
      # Enabling Gnome Keyring
      gnome-keyring.enable = true;

      # Configuring GnuPG agent
      gpg-agent = {
        enable = true;
        enableSshSupport = true;
        pinentryFlavor = "gnome3";
      };
    };
  };
}
