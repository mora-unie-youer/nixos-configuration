_:

{
  # Importing NixOS-related modules
  imports = [
    # NixOS configuration core
    ./core.nix

    # NixOS configuration bootloader and filesystem
    ./boot.nix
    ./filesystem.nix
  ];
}
