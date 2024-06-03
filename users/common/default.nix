{ pkgs, ... }:

let
  core-packages = with pkgs; [
    libnotify
    xdg-utils
  ];

  font-packages = with pkgs; [
    # corefonts
    font-awesome
    liberation_ttf
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
  ];
in
{
  ###
  ### DEFAULT CONFIGURATION
  ###
  programs.home-manager.enable = true;
  home.stateVersion = "24.05";
  home.sessionVariables = {};
  gtk.enable = true;
  xdg.enable = true;

  ###
  ### CORE
  ###
  home.packages = core-packages ++ font-packages;

  ###
  ### SHELLS
  ###
  programs = {
    bash.enable = true;
    fish.enable = true;
    ion.enable = true;
    nushell.enable = true;
    zsh.enable = true;

    tmux.enable = true;
    zellij.enable = true;

    atuin.enable = true;
    starship.enable = true;

    bat.enable = true;
    eza.enable = true;
    fzf.enable = true;
    ripgrep.enable = true;
    zoxide.enable = true;

    direnv.enable = true;
    direnv.nix-direnv.enable = true;
  };

  ###
  ### XDG PORTALS
  ###
  # NOTE: I'm trying to move portals to user configuration...
  #       But Flatpak requires it on the system config side,
  #       so I can't do this for now
  # xdg.portal = {
  #   enable = true;
  #   extraPortals = with pkgs; [ xdg-desktop-portal-gnome xdg-desktop-portal-gtk ];
  #   config.common.default = [ "gnome" "gtk" ];
  #   xdgOpenUsePortal = true;
  # };
}
