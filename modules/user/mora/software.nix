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
