{ pkgs, config, ... }:

{
  # Configuring kernel and bootloader
  config = {
    boot = {
      # Adding kernel modules for Thinkpad P53s
      kernelModules = [ "acpi_call"  "kvm-intel" ];
      kernelPackages = pkgs.linuxPackages_zen;
      extraModulePackages = with config.boot.kernelPackages; [ acpi_call v4l2loopback ];
      extraModprobeConfig = ''
        options i915 enable_guc=2
      '';

      initrd = {
        # Adding required modules for Thinkpad P53s
        availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
        kernelModules = [ "dm-snapshot" "i915" ];

        luks.devices."p53s_crypt" = {
          device = "/dev/disk/by-uuid/89d0a97a-e3ab-4840-a2c2-dc665dc66e1b";
          preLVM = true;
          allowDiscards = true;
        };
      };

      # Using lanzaboote as bootloader
      lanzaboote = {
        enable = true;
        privateKeyFile = "/etc/secureboot/keys/db/db.key";
        publicKeyFile = "/etc/secureboot/keys/db/db.pem";
      };

      loader.efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/efi";
      };
    };
  };
}
