{ pkgs, ... }:

{
  # Configuring "generic" user software
  config = {
    # "Global" packages
    home.packages = with pkgs; [];
  };
}
