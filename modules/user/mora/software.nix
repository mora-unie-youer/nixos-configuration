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

      # GUI utilities
      bemenu
      copyq
      (discord-canary.override { withOpenASAR = true; })

      # Steam
      steam
      steam.run
    ];

    # Configuring programs
    programs = {
      # Configuring foot terminal
      foot.enable = true;
    };

    # Configuring services
    services = {
      # Enabling Gnome Keyring
      gnome-keyring.enable = true;
    };
  };
}
