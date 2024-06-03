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
    interfaces.enp5s0.useDHCP = true;
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

    yggdrasil = {
      enable = true;
      openMulticastPort = true;
      configFile = ../../secrets/yggdrasil-sapphire.conf;
      settings = {
        Peers = [
          "tcp://ygg-msk-1.averyan.ru:8363"
          "tls://ygg-msk-1.averyan.ru:8362"
          "quic://ygg-msk-1.averyan.ru:8364"

          # sergeysedoy97, x-mow-1, 200 Mbit/s, Dual-Stack (средний пинг 4ms)
          "tcp://185.103.109.63:65533"
          "tcp://[2a09:5302:ffff::ac9]:65533"
          "tls://185.103.109.63:65534"
          "tls://[2a09:5302:ffff::ac9]:65534"
          "quic://185.103.109.63:65535"
          "quic://[2a09:5302:ffff::ac9]:65535"

          # sergeysedoy97, x-mow-2, 100 Mbit/s, Dual-Stack (средний пинг 4ms)
          "tcp://45.95.202.91:65533"
          "tcp://[2a09:5302:ffff::aca]:65533"
          "tls://45.95.202.91:65534"
          "tls://[2a09:5302:ffff::aca]:65534"
          "quic://45.95.202.91:65535"
          "quic://[2a09:5302:ffff::aca]:65535"

          # sergeysedoy97, x-mow-3, 100 Mbit/s, Dual-Stack (средний пинг 4ms)
          "tcp://[2a00:b700::c:2e1]:65533"
          "tls://[2a00:b700::c:2e1]:65534"
          "quic://[2a00:b700::c:2e1]:65535"

          # sergeysedoy97, x-mow-4, 100 Mbit/s, Dual-Stack (средний пинг 5ms)
          "tcp://[2a00:b700:3::3:3b4]:65533"
          "tls://[2a00:b700:3::3:3b4]:65534"
          "quic://[2a00:b700:3::3:3b4]:65535"

          # sergeysedoy97, x-mow-0, 1 Gbit/s, Dual-Stack (средний пинг 15ms)
          "tcp://178.20.41.3:65533"
          "tcp://[2a0d:8480:2:6bd::]:65533"
          "tls://178.20.41.3:65534"
          "tls://[2a0d:8480:2:6bd::]:65534"
          "quic://178.20.41.3:65535"
          "quic://[2a0d:8480:2:6bd::]:65535"
        ];
      };
    };
  };
}
