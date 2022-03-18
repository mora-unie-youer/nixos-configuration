{ config, pkgs, ... }:

with pkgs.lib;

let
  options = {
    boot.loader.efiStub = {
      enable = mkOption {
        default = false;
        description = ''
          Whether to use EFISTUB feature.
          If enabled, copies kernel and initramfs to EFI partition to make
          system bootable.
        '';
      };

      useEfibootmgr = mkOption {
        default = false;
        description = ''
          Whether to run efibootmgr to add boot entries.
        '';
      };

      efiDisk = mkOption {
        default = "/dev/sda";
        description = ''
          The disk device with EFI partition
        '';
      };

      efiPart = mkOption {
        default = 1;
        description = ''
          EFI partition number on the disk
        '';
      };
    };
  };
in

let
  efiStubBuilder = pkgs.substituteAll {
    src = ./efistub-builder.sh;
    isExecutable = true;

    inherit (pkgs) bash;
    path = [pkgs.coreutils pkgs.gnugrep pkgs.gnused pkgs.glibc] ++ (pkgs.stdenv.lib.optionals config.boot.loader.efiStub.useEfibootmgr [pkgs.efibootmgr]);
    inherit (config.boot.loader.efi) efiSysMountPoint;
    inherit (config.boot.loader.efiStub) useEfibootmgr efiDisk efiPart;
  };
in
{
  require = [ options ];

  system = mkIf (config.boot.loader.efiStub.enable && (assert
      (config.boot.kernelPackages.kernel.features ? efiBootStub &&
       config.boot.kernelPackages.kernel.features.efiBootStub); true)) {
    build = { menuBuilder = efiStubBuilder; };
    boot.loader.id = "efiStub";
    boot.loader.kernelFile = pkgs.stdenv.platform.kernelTarget;
  };
}
