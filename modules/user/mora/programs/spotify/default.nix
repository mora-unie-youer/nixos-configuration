{ pkgs, ... }:

pkgs.spotify.overrideAttrs (old: {
  nativeBuildInputs =
    with pkgs; [ perl unzip util-linux zip ]
      ++ old.nativeBuildInputs;

  postInstall = ''
    ${builtins.readFile ./spotx.sh}
  '';
})
