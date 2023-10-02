_:

{
  # Importing everything related to "mora" user
  imports = [
    ./software.nix
  ];

  # Configuring common user
  config = {
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
