{ nurpkgs, ... }:

{
  # Importing everything related to "mora" user
  imports = [
    ./git.nix
    ./input.nix
    ./mako.nix
    ./mpv.nix
    ./helix.nix
    ./hyprland.nix
    ./software.nix
    ./swayidle.nix
    ./theme.nix

    ./programs/firefox
    ./programs/waybar
  ];

  # Configuring common user
  config = {
    # Configuring Nixpkgs and its overlays
    nixpkgs = {
      config = {
        allowBroken = true;
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };

      overlays = [
        (final: prev: {
          nur = import nurpkgs {
            nurpkgs = prev;
            pkgs = prev;
          };
        })
      ];
    };

    # Configuring home-manager
    home = {
      # Setting some user information
      username = "mora";
      homeDirectory = "/home/mora";

      # "Local" environment variables
      sessionVariables = {};
    };
  };
}
