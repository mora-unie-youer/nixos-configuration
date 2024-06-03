{ pkgs, stdenv, fetchzip, lib }:

let x64gram-desktop-bin = stdenv.mkDerivation rec {
  pname = "64gram";
  version = "1.1.23";

  src = fetchzip {
    url = "https://github.com/TDesktop-x64/tdesktop/releases/download/v${version}/64Gram_${version}_linux.zip";
    # sha256 = "sha256-loGjcQCDmotN4JF4G3YVQL+3KHD7WiQ/kz/YNzrXetA=";
    sha256 = "sha256-vvjzY/OCx1GlhH4WuyZAKrvKKphs8Nnt4oaGxpPZJiw=";
    stripRoot = false;
  };

  installPhase = "mkdir -p $out/bin/ && cp ./Telegram $out/bin/";
}; in pkgs.buildFHSUserEnv {
  name = "${x64gram-desktop-bin.pname}";

  targetPkgs = with pkgs; pkgs: [
    x64gram-desktop-bin

    dbus
    glib
    gtk3
    fontconfig
    freetype
    # libdbusmenu
    libGL
    libglvnd
    libpulseaudio
    # shared-mime-info
    wayland
    # webkitgtk_6_0
    xdg-utils

    xorg.libxcb
    xorg.libX11
    xorg.xkeyboardconfig
  ];

  runScript = "Telegram";

  profile = let
    schema = pkgs.gsettings-desktop-schemas;
    gtk = pkgs.gtk3;
    datadir = "${schema}/share/gsettings-schemas/${schema.name}:${gtk}/share/gsettings-schemas/${gtk.name}";
  in ''
    export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
    # export QT_QPA_PLATFORM=xcb
  '';
  
  meta = with lib; {
    description = "Unofficial desktop version of Telegram messaging app";
    homepage = "https://github.com/TDesktop-x64/tdesktop/tree/v${x64gram-desktop-bin.version}";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
  };
}
