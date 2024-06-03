{ modulesPath, pkgs, ... }:

{
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  ###
  ### DEFAULT CONFIGURATION
  ###
  security.rtkit.enable = true;
  musnix.enable = true;
  programs.fuse.userAllowOther = true;

  ### 
  ### NIXPKGS
  ### 
  nixpkgs.config.allowUnfree = true;

  ### 
  ### FILESYSTEM
  ### 
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NixOS";
      fsType = "btrfs";
    };

    # EFI
    "/efi" = {
      device = "/dev/disk/by-label/EFI";
      fsType = "vfat";
    };
  };

  ###
  ### BOOT
  ###
  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/efi";
  };

  ###
  ### CORE
  ###
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Etc/GMT";
  sound.enable = true;
  environment.shells = [ pkgs.fish ];

  hardware = {
    opengl = {
      enable = true;
      driSupport32Bit = true;
    };

    opentabletdriver.enable = true;

    sane = {
      enable = true;
      extraBackends = [ pkgs.hplip ];
    };
  };

  networking.extraHosts = ''
    213:c0de:ceca:57f4:2e2e:8ed6:c071:f52f sapphire-ygg
    21b:4bb0:4b16:c71c:eada:1a48:c543:4618 thinkpad-p53s-ygg
  '';

  security.polkit.enable = true;

  services = {
    fwupd.enable = true;
    dbus.packages = with pkgs; [ dconf gcr ];
    udisks2.enable = true;
    upower.enable = true;
    udev.packages = with pkgs; [ stlink ];
  };

  ###
  ### SOFTWARE
  ###
  environment.systemPackages = with pkgs; [
    neofetch onefetch
    helix tmux zellij
    file p7zip unrar zip
    curl wget
    git git-crypt
  ];

  fonts = {
    fontconfig.useEmbeddedBitmaps = true;
    packages = with pkgs; [ dejavu_fonts ];
  };

  programs = {
    adb.enable = true;
    dconf.enable = true;
    fish.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  services = {
    gnome.gnome-remote-desktop.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
      pulse.enable = true;
    };

    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
    };
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gnome xdg-desktop-portal-gtk ];
    config.common.default = [ "gnome" "gtk" ];
  };
}
