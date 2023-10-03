{ pkgs, ... }:

{
  # Configuring "mora" user software
  config = {
    # "Local" packages
    home.packages = with pkgs; [
      # Shell utilities
      ffmpeg-full

      # GUI utilities
      bemenu
      copyq
      (discord-canary.override { withOpenASAR = true; })
    ];

    # Configuring programs
    programs = {
      # Configuring foot terminal
      foot.enable = true;
    };
  };
}
