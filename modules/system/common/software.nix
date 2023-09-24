{ pkgs, ... }:

{
  # Configuring some generic software on every machine
  config = {
    # Including some packages into system environment
    #
    # Should be used for packages that I use the most at any user
    # or everytime install using `nix-shell -p`
    environment.systemPackages = with pkgs; [
      # ~~Just to look cool~~
      neofetch
      onefetch

      # Some terminal multiplexers
      tmux
      zellij

      # Some terminal tools
      file
      killall

      # Some editor (best editor tbh)
      helix

      # Some archive managers
      p7zip
      unrar
      zip

      # Some access to internet
      #curl -> is already installed
      wget
    ];

    # Configuring fonts and fontconfig
    fonts = {
      # Configuring fontconfig options
      fontconfig = {
        useEmbeddedBitmaps = true;
      };

      # Installing some default fonts which are used everywhere
      packages = with pkgs; [ dejavu_fonts ];
    };

    # Configuring some programs
    programs = {
      # Enabling ADB
      adb.enable = true;

      # Enabling dconf
      dconf.enable = true;

      # Enabling hyprland protal
      hyprland.enable = true;

      # Enabling GPG agent
      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };

      # Enabling shells
      fish.enable = true;
      zsh.enable = true;
    };

    # Configuring some services
    services = {
      # Configuring audio server
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        jack.enable = true;
        pulse.enable = true;
      };

      # Configuring SSH server
      openssh.enable = true;
    };

    # Configuring XDG portals
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
  };
}
