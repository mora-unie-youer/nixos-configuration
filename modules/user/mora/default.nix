{ pkgs, ... }:

{
  # Importing everything related to "mora" user
  imports = [];

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
}
