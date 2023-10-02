_:

{
  config = {
    # Configuring GTK
    gtk = {
      enable = true;

      font = {
        name = "DejaVu Sans";
        size = 8;
      };

      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
        gtk-can-change-accels = 1;
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstyle = "hintmedium";
        gtk-xft-rgba = "rgb";
      };

      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstyle = "hintmedium";
        gtk-xft-rgba = "rgb";
      };
    };
  };
}