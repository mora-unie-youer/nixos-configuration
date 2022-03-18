# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  edid-G2255 = pkgs.callPackage ./edid {};
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.kernelParams = [ "drm.edid_firmware=DVI-I-1:edid/G2255.bin" ];
  hardware.firmware = with pkgs; [ edid-G2255 ];

  networking.hostName = "purhomb-mora"; # Define your hostname.
  networking.wireless.enable = true;    # Enables wireless support via wpa_supplicant.
  networking.useDHCP = true;
  # NOTE: I will add interfaces here when I will make first NixOS install.

  # I like to use UTC on my computers
  time.timeZone = null;

  sound.enable = true;
  # I'm using Pipewire :3
  services.pipewire = {
    enable = true;

    alsa.enable  = true;
    pulse.enable = true;
    jack.enable  = true;
  };

  users.users.mora = {
    description = "Mora Unie Youer";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
