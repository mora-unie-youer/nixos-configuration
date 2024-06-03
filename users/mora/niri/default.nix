{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libxkbcommon
, pango
, pipewire
, seatd
, stdenv
, wayland
, systemd
, libinput
, mesa
, fontconfig
, libglvnd
, autoPatchelfHook
, clang
}:

rustPlatform.buildRustPackage {
  pname = "niri";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "YaLTeR";
    repo = "niri";
    rev = "bcca03cce7da9dc4125aa34943041cb65e0fd4bb";
    hash = "sha256-slcyV/LoXYRIwhHJI3SBpWRBRnONsT0dH26mvBs8Bos=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "smithay-0.3.0" = "sha256-UzX5pws8yxJhXdKIDzu6uw+PlVLRS9U9ZAfQovKv0w0=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    autoPatchelfHook
    clang
  ];

  buildInputs = [
    wayland
    systemd # For libudev
    seatd # For libseat
    libxkbcommon
    libinput
    mesa # For libgbm
    fontconfig
    stdenv.cc.cc.lib
    pipewire
    pango
  ];

  runtimeDependencies = [
    wayland
    mesa
    libglvnd # For libEGL
  ];

  passthru.providedSessions = ["niri"];

  postPatch = ''
    patchShebangs ./resources/niri-session
    substituteInPlace ./resources/niri.service \
      --replace-fail '/usr/bin' "$out/bin"
  '';

  postInstall = ''
    install -Dm0755 ./resources/niri-session -t $out/bin
    install -Dm0644 resources/niri.desktop -t $out/share/wayland-sessions
    install -Dm0644 resources/niri-portals.conf -t $out/share/xdg-desktop-portal
    install -Dm0644 resources/niri{-shutdown.target,.service} -t $out/share/systemd/user
  '';

  meta = with lib; {
    description = "A scrollable-tiling Wayland compositor";
    homepage = "https://github.com/YaLTeR/niri";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ iogamaster foo-dogsquared sodiboo ];
    mainProgram = "niri";
    platforms = platforms.linux;
  };
}
