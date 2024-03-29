{ modulesPath, ... }:

{
  # Importing some kernel modules automatically
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  config = {
    # Setting up all boot(-loader)-related things
    boot = {
      # Setting up EFI bootloaders
      loader.efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/efi";
      };
    };
  };
}
