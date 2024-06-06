{ pkgs, pollymc, ... }:

{
  imports = [
    ./firefox
    ./mpv.nix
    ./wayland.nix
  ];

  ###
  ### HOME-MANAGER
  ###
  home.username = "mora";
  home.homeDirectory = "/home/mora";
  home.sessionVariables = {};

  ### 
  ### NIXPKGS
  ### 
  nixpkgs.config.allowUnfree = true;

  ###
  ### GPG
  ###
  programs.gpg = {
    enable = true;

    settings = {
      ask-cert-level = true;
      expert = true;

      list-options = [ "show-sig-expire" "show-uid-validity" "show-unusable-subkeys" "show-unusable-uids"];
      verify-options = [ "show-uid-validity" "show-unusable-uids" ];

      # Repeat with-fingerprint twice
      with-fingerprint = [ "" "" ];
      with-keygrip = true;
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };

  ###
  ### GNOME KEYRING
  ###
  services.gnome-keyring = {
    enable = true;
    components = [ "secrets" "ssh" ];
  };

  ###
  ### GIT
  ###
  programs.git = {
    enable = true;
    delta.enable = true;

    includes = [{
      contents = {
        user.name = "Mora Unie Youer";
        user.email = "mora_unie_youer@riseup.net";
        user.signingKey = "0x7AB91D83B25E6D7F";

        commit.gpgSign = true;
        init.defaultBranch = "master";
        safe.directory = "*";
      };
    }];
  };

  ###
  ### FCITX 5
  ###
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      fcitx5-mozc
      libsForQt5.fcitx5-qt
    ];
  };

  ###
  ### PROGRAMS
  ###
  home.packages = with pkgs; [
    sxiv
    zathura

    ffmpeg
    obs-studio

    pollymc.packages.${pkgs.system}.default
    zulu17

    (pkgs.callPackage ./repo/64gram-desktop-bin.nix {})
    (pkgs.callPackage ./repo/vesktop {})

    (pkgs.callPackage ./repo/osu.nix {})
  ];

  programs.atuin.flags = [ "--disable-up-arrow" ];

  services.easyeffects.enable = true;

  ###
  ### THEME
  ###
  home.pointerCursor = {
    package = pkgs.catppuccin-cursors.mochaMauve;
    name = "catppuccin-mocha-mauve-cursors";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };
}
