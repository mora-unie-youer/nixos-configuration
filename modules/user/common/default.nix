{ pkgs, ... }:

{
  # Importing everything related to common user
  imports = [];

  # Configuring common user
  config = {
    # Configuring home-manager
    home = {
      # Setting some state version
      stateVersion = "23.11";

      # "Global" environment variables
      sessionVariables = {};

      # "Global" packages
      packages = with pkgs; [];
    };
  };
}
