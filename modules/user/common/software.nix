{ pkgs, ... }:

{
  # Configuring "generic" user software
  config = {
    # "Global" packages
    home.packages = with pkgs; [
      # Core
      brightnessctl
      libnotify
      xdg-utils

      # Fonts
      corefonts
      liberation_ttf
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
      noto-fonts
      noto-fonts-cjk
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji

      # Shell utilities
      bottom
      dua
      fd
      lm_sensors
      htop
      wl-clipboard
    ];

    # Configuring programs
    programs = {
      # Configuring Home Manager
      home-manager.enable = true;

      # Configuring Bash
      bash.enable = true;

      # Configuring Fish
      fish = {
        enable = true;
        interactiveShellInit = ''
          # The following snippet is meant to be used like this in your fish config:
          #
          # if status is-interactive
          #     # Configure auto-attach/exit to your likings (default is off).
          #     # set ZELLIJ_AUTO_ATTACH true
          #     # set ZELLIJ_AUTO_EXIT true
          #     eval (zellij setup --generate-auto-start fish | string collect)
          # end

          set ZELLIJ_AUTO_EXIT true
          if not set -q ZELLIJ
            if not string match -q "/dev/tty*" (tty)
              if test "$ZELLIJ_AUTO_ATTACH" = "true"
                zellij attach -c
              else
                zellij
              end

              if test "$ZELLIJ_AUTO_EXIT" = "true"
                kill $fish_pid
              end
            end
          end
        '';
      };

      # Configuring Ion
      ion.enable = true;

      # Configuring Nushell
      nushell.enable = true;

      # Configuring ZSH
      zsh.enable = true;

      # Configuring zellij
      zellij = {
        enable = true;
        enableBashIntegration = true;
        # enableFishIntegration = true;
        enableZshIntegration = true;
      };

      # Configuring Atuin (Ctrl-R in shell)
      atuin = {
        enable = true;
        flags = [ "--disable-up-arrow" ];
      };

      # Configuring Starship (pretty prompt)
      starship = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableIonIntegration = true;
        enableNushellIntegration = true;
        enableZshIntegration = true;
      };

      # Configuring FZF
      fzf.enable = true;
    };
  };
}
