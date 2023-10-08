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
      font-awesome
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
      zellij.enable = true;

      # Configuring Atuin (Ctrl-R in shell)
      atuin = {
        enable = true;
        flags = [ "--disable-up-arrow" ];
      };

      # Enabling bat
      bat.enable = true;

      # Configuring exa
      eza = {
        enable = true;
        enableAliases = true;
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

      # Enabling ripgrep
      ripgrep.enable = true;

      # Enabling zoxide
      zoxide.enable = true;
    };
  };
}
