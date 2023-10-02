{ pkgs, ... }:

{
  # Configuring "mora" user software
  config = {
    # "Local" packages
    home.packages = with pkgs; [];
  };
}