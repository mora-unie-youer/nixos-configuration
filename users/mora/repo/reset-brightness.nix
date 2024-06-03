{ pkgs, ... }:

pkgs.writeShellScriptBin "reset-brightness" ''
  busctl --user -- set-property rs.wl-gammarelay / rs.wl.gammarelay Brightness d 1

  busctl --user -- set-property rs.wl-gammarelay /outputs/HDMI_A_2 rs.wl.gammarelay Brightness d 0.8
  busctl --user -- set-property rs.wl-gammarelay /outputs/DVI_D_1 rs.wl.gammarelay Brightness d 0.75
  busctl --user -- set-property rs.wl-gammarelay /outputs/HDMI_A_3 rs.wl.gammarelay Brightness d 0.7
''
