{ config, lib, pkgs, ... }:

{
  ###
  ### FILESYSTEM
  ###
  fileSystems = {
    "/data" = {
      device = "/dev/disk/by-uuid/2874dc1d-f1b5-4200-a5de-8dd555fa58c8";
      fsType = "btrfs";
    };
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/37e818f5-1460-4f22-8207-5ad94b5ec8c4"; }
  ];

  ###
  ### BOOT
  ###
  boot = {
    kernelModules = [ "corefreqk" "kvm-amd" ];
    kernelPackages = pkgs.linuxPackages_zen;
    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback zenpower ];

    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
      kernelModules = [ "amdgpu" "dm-snapshot" ];
    };

    lanzaboote = {
      enable = true;
      privateKeyFile = "/etc/secureboot/keys/db/db.key";
      publicKeyFile = "/etc/secureboot/keys/db/db.pem";
    };
  };

  ###
  ### HARDWARE
  ###
  hardware = {
    bluetooth.enable = true;
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    opengl.extraPackages = with pkgs; [ rocmPackages.clr.icd ];
  };

  ###
  ### NETWORKING
  ###

  networking = {
    hostName = "sapphire";
    interfaces.enp7s0.useDHCP = true;
    networkmanager.enable = true;

    firewall = {
      allowedTCPPorts = [ 8222 25565 ];
      allowedUDPPorts = [];
    };
  };

  services = {
    fstrim.enable = true;
    tlp.enable = true;
    xserver.videoDrivers = [ "amdgpu" ];
  };

  ###
  ### SOFTWARE
  ###
  services = {
    flatpak.enable = true;
    resolved.enable = true;
    yggdrasil.configFile = ../../secrets/yggdrasil-sapphire.conf;
  };
}
