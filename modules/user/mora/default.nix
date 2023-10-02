_:

{
  # Importing everything related to "mora" user
  imports = [
    ./input.nix
    ./hyprland.nix
    ./software.nix
  ];

  # Configuring common user
  config = {
    nixpkgs.config = {
      allowBroken = true;
      allowUnfree = true;
      allowUnfreePredicate = _: true;
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
