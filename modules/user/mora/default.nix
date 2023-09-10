{ pkgs, ... }:

{
  # Importing everything related to "mora" user
  imports = [];

  # Configuring common user
  config = {
    # Configuring home-manager
    home = {
      # Setting some user information
      username = "mora";
      homeDirectory = "/home/mora";

      # "Local" environment variables
      sessionVariables = {};

      # "Local" packages
      packages = with pkgs; [];
    };
  };
}
