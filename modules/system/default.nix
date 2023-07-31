{ inputs }:

_:

{
  # Importing NixOS-related modules
  imports = [
    # Importing all required modules
    inputs.lanzaboote.nixosModules.lanzaboote

    # NixOS configuration core
    ./core.nix

    # NixOS configuration bootloader and filesystem
    ./boot.nix
    ./filesystem.nix
  ];
}
