{ pkgs, lib, ... }:


let
  mpvacious' = pkgs.mpvScripts.mpvacious.overrideAttrs (old: rec {
    version = "0.26";

    src = pkgs.fetchFromGitHub {
      owner = "Ajatt-Tools";
      repo = "mpvacious";
      rev = "v${version}";
      sha256 = "sha256-QPLJC6SxocvOPeY6qI8q+EyXNGVef3J/Z38W0/rzFCg=";
    };
  });
in
{
  programs.mpv = {
    enable = true;

    bindings = {
      "h" = "seek -5";
      "j" = "seek -60";

      "l" = "seek 5";
      "k" = "seek 60";

      "z" = "add sub-delay -0.001";
      "Z" = "add sub-delay +0.001";
      "Ctrl+z" = "set sub-delay 0";

      "x" = "sub-step -1";
      "X" = "sub-step 1";

      "Ctrl+j" = "cycle secondary-sid";
      "Ctrl+J" = "cycle secondary-sid down";
    };

    config = {
      # Cache
      cache = "auto";
      demuxer-max-bytes = "1800M";
      demuxer-max-back-bytes = "1200M";

      # Logging
      msg-color = true;
      msg-module = true;

      # Color space
      target-trc = "auto";
      vf = "format=colorlevels=full:colormatrix=auto";

      # Dithering
      dither = "fruit";
      dither-depth = "auto";
      temporal-dither = true;

      # Motion Interpolation
      interpolation = true;
      display-fps-override = "60";
      tscale = "oversample";
      video-sync = "display-resample";

      # Video
      vo = "gpu";
      profile = "gpu-hq";
      hwdec = "auto";

      # Audio
      af-add = "dynaudnorm=g=5:f=250:r=0.9:p=0.5";
      audio-file-auto = "fuzzy";
      audio-pitch-correction  = true;

      # Subtitles
      blend-subtitles = true;
      demuxer-mkv-subtitle-preroll = true;
      embeddedfonts = true;
      sub-ass-force-margins = true;
      sub-ass-style-overrides = "Kerning=yes";
      sub-ass-override = "force";
      sub-auto = "fuzzy";
      sub-border-color = "#FF262626";
      sub-border-size = 2;
      sub-color = "#FFFFFFFF";
      sub-font-size = 40;
      sub-shadow-color = "#33000000";
      sub-shadow-offset = 1;
      sub-spacing = 0.5;
      sub-use-margins = true;

      # Misc
      hls-bitrate = "max";
      osd-bar-align-y = 0;
      osd-bar-w = 60;
      osd-bar-h = 2.125;
      osd-bold = false;
      osd-border-color = "#DD322640";
      osd-border-size = 2;
      osd-color = "#CCFFFFFF";
      osd-duration = 3000;
      osd-font-size = 18;
      osd-level = 3;
      save-position-on-quit = true;

      # Youtube + Sponsorblock
      script-opts-append = "sponsorblock-local_database=no";
      ytdl-format = "bestvideo[height<=?720]+bestaudio/best";
    };

    scripts = with pkgs.mpvScripts; [ mpvacious' ];
  };
}
