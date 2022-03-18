{ stdenv }:

stdenv.mkDerivation rec {
  pname   = "edid-G2255";
  version = "1";
  meta    = {
    description = "EDID file for BenQ G2255 monitor";
    maintainers = [ "Mora Unie Youer <mora_unie_youer@riseup.net>" ];
    platforms   = stdenv.lib.platforms.linux;
  };

  src = ./firmware;
  installPhase = ''
    mkdir -p $out/lib/firmware
    cp -r  * $out/lib/firmware
  '';
}
