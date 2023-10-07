{ pkgs, ... }:

let
  breeze-purple-cursor-theme = pkgs.stdenv.mkDerivation {
    pname = "breeze-purple-cursor-theme";
    version = "1.0";

    src = pkgs.fetchurl {
      url = "https://code.jpope.org/jpope/breeze_cursor_sources/raw/master/breeze-purple-cursor-theme.zip";
      sha256 = "ed7944b0175b455b5ebce8b0937936a5defda992f54830d5ef98b90a8d422b11";
    };

    nativeBuildInputs = with pkgs; [ unzip ];

    installPhase = ''
      install -d $out/share/icons/Breeze_Purple
      cp -rf *   $out/share/icons/Breeze_Purple
    '';

    meta = with pkgs.lib; {
      description = "Breeze Purple cursor theme";
      license = licenses.gpl2;
      platforms = [ "x86_64-linux" ];
    };
  };
in
{
  home.pointerCursor = {
    package = breeze-purple-cursor-theme;
    name = "Breeze_Purple";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  gtk = {
    iconTheme = {
      name = "Flat-Remix-Violet-Dark";
      package = pkgs.flat-remix-icon-theme;
    };

    theme = {
      name = "Flat-Remix-GTK-Violet-Darkest-Solid";
      package = pkgs.flat-remix-gtk;
    };
  };
}
