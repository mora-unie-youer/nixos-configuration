{ pkgs, pollymc, ... }:

{
  imports = [
    ./development.nix
    ./firefox
    ./mpv.nix
    ./wayland.nix
  ];

  ###
  ### HOME-MANAGER
  ###
  home.username = "mora";
  home.homeDirectory = "/home/mora";
  home.sessionVariables = {
    GTK_USE_PORTAL = 1;
  };

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
    libreoffice-still
    sxiv
    zathura

    anydesk

    element-desktop
    (pkgs.writeShellScriptBin "x2wayland" ''
      type=$(xclip -sel c -t TARGETS -o | grep -P '^[a-z]+/[a-z]+$' | bemenu --single-instance)
      xclip -sel c -t "$type" -o | wl-copy -t "$type"
    '')

    (pkgs.writeShellScriptBin "wayland2x" ''
      type=$(wl-paste -l | grep -P '^[a-z]+/[a-z]+$' | bemenu --single-instance)
      wl-paste -t "$type" | xclip -selection clipboard -t "$type" -i
    '')


    ffmpeg
    obs-studio
    youtube-music

    pollymc.packages.${pkgs.system}.default
    zulu17

    bottles
    qbittorrent

    (pkgs.callPackage ./repo/64gram-desktop-bin.nix {})
    (pkgs.callPackage ./repo/vesktop {})

    (pkgs.callPackage ./repo/osu.nix {})
  ];

  ###
  ### SHELL
  ###
  programs.atuin.flags = [ "--disable-up-arrow" ];
  programs.tmux = {
    enable = true;

    disableConfirmationPrompt = true;
    escapeTime = 0;
    mouse = true;
    historyLimit = 10000;
    terminal = "tmux-256color";

    sensibleOnTop = false;
    plugins = with pkgs.tmuxPlugins; [
      better-mouse-mode

      {
        plugin = catppuccin;
        extraConfig = "set -g @catppuccin_flavour 'mocha'";
      }
    ];

    extraConfig = ''
      bind-key -n M-c new-window
      bind-key -n M-[ previous-window
      bind-key -n M-] next-window

      bind-key -n M-n split-window -h -c "#{pane_current_path}"
      bind-key -n M-N split-window -v -c "#{pane_current_path}"
      bind-key -n M-w choose-tree
      bind-key -n M-x kill-pane
      bind-key -n M-X kill-pane -a

      bind-key -n M-k select-pane -U
      bind-key -n M-Up select-pane -U
      bind-key -n M-K resize-pane -U 2
      bind-key -n M-S-Up resize-pane -U 2
      bind-key -n M-j select-pane -D
      bind-key -n M-Down select-pane -D
      bind-key -n M-J resize-pane -D 2
      bind-key -n M-S-Down resize-pane -D 2
      bind-key -n M-h select-pane -L
      bind-key -n M-Left select-pane -L
      bind-key -n M-H resize-pane -L 2
      bind-key -n M-S-Left resize-pane -L 2
      bind-key -n M-l select-pane -R
      bind-key -n M-Right select-pane -R
      bind-key -n M-L resize-pane -R 2
      bind-key -n M-S-Right resize-pane -R 2
    '';
  };

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
