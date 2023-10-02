{ pkgs, ... }:

{
  # Configuring "generic" user software
  config = {
    # "Global" packages
    home.packages = with pkgs; [];

    # Configuring programs
    programs = {
      # Configuring Home Manager
      home-manager.enable = true;

      # Configuring Bash
      bash.enable = true;

      # Configuring Fish
      fish.enable = true;

      # Configuring Ion
      ion.enable = true;

      # Configuring Nushell
      nushell.enable = true;

      # Configuring ZSH
      zsh.enable = true;
    };
  };
}
