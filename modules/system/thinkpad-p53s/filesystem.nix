_:

{
  # Setting up all filesystem-related things on Thinkpad P53s
  config = {
    fileSystems = {
      # Data partition
      "/data" = {
        device = "/dev/disk/by-uuid/a8650555-83d0-4607-9ea7-9dde2b2bbf0c";
        fsType = "btrfs";
      };

      # Music partition
      "/music" = {
        device = "/dev/disk/by-uuid/fa03295f-1e14-4259-ad74-8844bae6db9c";
        fsType = "btrfs";
      };

      # Programming partition
      "/prog" = {
        device = "/dev/disk/by-uuid/2e007f09-d8af-47fb-8635-8b2b97690084";
        fsType = "btrfs";
      };

      # HDD archive
      "/hdd" = {
        device = "/dev/disk/by-uuid/2ac49880-dad1-47ca-be2c-e616dab0ea1c";
        fsType = "btrfs";
        options = [ "noauto" ];
      };
    };

    swapDevices = [
      { device = "/dev/disk/by-uuid/e06bf570-8bb5-409b-a708-6d6435ad1481"; }
    ];
  };
}
