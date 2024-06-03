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
  environment.shells = [ pkgs.fish pkgs.nushell ];
  environment.sessionVariables.GTK_USE_PORTAL = "1";

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

    yggdrasil = {
      enable = true;
      openMulticastPort = true;
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

  # NOTE: Enabling XDG Portal here as Flatpak requires it...
  #       For now I'm trying to move XDG Portals to user configuration...
  xdg.portal = let
    xdg-desktop-portal-gtk' = pkgs.xdg-desktop-portal-gtk.overrideAttrs (prev: {
      patchPhase = ''
        patch -Np1 <<EOF
        diff --git a/data/xdg-desktop-portal-gtk.service.in b/data/xdg-desktop-portal-gtk.service.in
        index b82a039..2f3c09a 100644
        --- a/data/xdg-desktop-portal-gtk.service.in
        +++ b/data/xdg-desktop-portal-gtk.service.in
        @@ -1,5 +1,8 @@
         [Unit]
         Description=Portal service (GTK/GNOME implementation)
        +After=graphical-session.target
        +Requisite=graphical-session.target
        +PartOf=graphical-session.target
 
         [Service]
         Type=dbus
        EOF
      '';
    });
  in {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gnome xdg-desktop-portal-gtk' ];
    config.common.default = "*";
    xdgOpenUsePortal = true;
  };
}
