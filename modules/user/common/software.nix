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
      fish.enable = true;

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
        enableFishIntegration = true;
        enableZshIntegration = true;
      };

      # Configuring Atuin (Ctrl-R in shell)
      atuin = {
        enable = true;
        flags = [ "--disable-up-arrow" ];
      };

      # Configuring FZF
      fzf.enable = true;
    };
  };
}
