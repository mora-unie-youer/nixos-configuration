{ pkgs, ... }:

{
  # Setting up core features in NixOS configuration
  config = {
    # Setting up default locale to en_US.UTF-8
    i18n.defaultLocale = "en_US.UTF-8";

    # Setting up system timezone to UTC
    time.timeZone = "UTC";

    # Setting up global (system) environment
    environment = {
      # Including some packages into system environment
      #
      # Should be used for packages that I use the most at any user
      # or everytime install using `nix-shell -p`
      systemPackages = with pkgs; [
        # ~~Just to look cool~~
        neofetch
        onefetch

        # Some terminal multiplexers
        tmux
        zellij

        # Some archive managers
        p7zip
        unrar
        zip

        # Some access to internet
        #curl -> is already installed
        wget
      ];
    };

    # Setting up really important services
    services = {
      # Enabling fwupd
      fwupd.enable = true;

      # Adding modules for D-Bus
      dbus.packages = with pkgs; [ dconf gcr ];

      # Configuring audio server
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        jack.enable = true;
        pulse.enable = true;
      };

      # Enabling udisks2
      udisks2.enable = true;

      # Enabling upower
      upower.enable = true;
    };

    # Enabling some disabled documentation
    documentation = {
      dev.enable = true;
      man.generateCaches = true;
    };
  };
}
