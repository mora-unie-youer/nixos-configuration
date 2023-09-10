_:

{
  config = {
    # Setting up all boot(-loader)-related things
    boot = {
      # Setting up EFI bootloaders
      loader.efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/efi";
      };

      # Setting up Lanzaboote bootloader
      lanzaboote = {
        enable = true;
        privateKeyFile = "/etc/secureboot/keys/db/db.key";
        publicKeyFile = "/etc/secureboot/keys/db/db.pem";
      };
    };
  };
}
