# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  networking.hostName = "purhomb-mora"; # Define your hostname.
  networking.wireless.enable = true;    # Enables wireless support via wpa_supplicant.

  # I like to use UTC on my computers
  time.timeZone = null;

  sound.enable = true;
  # I'm using Pipewire :3
  hardware.pipewire.enable     = true;
  hardware.pipewire.alsa       = true;
  hardware.pipewire.pulseaudio = true;
  hardware.pipewire.jack       = true;

  users.users.mora = {
    description = "Mora Unie Youer";
    isNormalUser = true;

    createHome = true;

    group = "users";
    extraGroups = [ "wheel" ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

