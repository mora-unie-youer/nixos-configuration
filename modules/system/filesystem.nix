_:

{
  # Setting up all filesystem-related things
  config = {
    # These filesystems must be on any system I have
    fileSystems = {
      # Root partition
      "/" = {
        device = "/dev/disk/by-label/NixOS";
        fsType = "btrfs";
      };

      # ESP partition
      "/efi" = {
        device = "/dev/disk/by-label/EFI";
        fsType = "vfat";
      };
    };
  };
}
