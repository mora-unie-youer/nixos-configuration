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

  # patchPhase = ''
  #   patch -Np1 <<EOF
  #   diff --git a/resources/niri-session b/resources/niri-session
  #   index 85f6991..d54aa20 100755
  #   --- a/resources/niri-session
  #   +++ b/resources/niri-session
  #   @@ -17,6 +17,9 @@ if systemctl --user -q is-active niri.service; then
  #      exit 1
  #    fi
 
  #   +# Make sure everything in graphical-session.target is stopped
  #   +systemctl --user start --job-mode=replace-irreversibly niri-shutdown.target
  #   +
  #    # Reset failed state of all user units.
  #    systemctl --user reset-failed
 
  #   @@ -38,4 +41,4 @@ systemctl --user --wait start niri.service
  #    systemctl --user start --job-mode=replace-irreversibly niri-shutdown.target
 
  #    # Unset environment that we've set.
  #   -systemctl --user unset-environment WAYLAND_DISPLAY XDG_SESSION_TYPE XDG_CURRENT_DESKTOP NIRI_SOCKET
  #   +systemctl --user unset-environment DISPLAY WAYLAND_DISPLAY XDG_SESSION_TYPE XDG_CURRENT_DESKTOP NIRI_SOCKET
  #   diff --git a/src/main.rs b/src/main.rs
  #   index b5576e8..08dafe0 100644
  #   --- a/src/main.rs
  #   +++ b/src/main.rs
  #   @@ -184,6 +184,9 @@ fn main() -> Result<(), Box<dyn std::error::Error>> {
  #        )
  #        .unwrap();
 
  #   +    // Set DISPLAY for children (to use xwayland-satellite)
  #   +    env::set_var("DISPLAY", ":0");
  #   +
  #        // Set WAYLAND_DISPLAY for children.
  #        let socket_name = &state.niri.socket_name;
  #        env::set_var("WAYLAND_DISPLAY", socket_name);
  #   @@ -264,6 +267,7 @@ fn main() -> Result<(), Box<dyn std::error::Error>> {
 
  #    fn import_environment() {
  #        let variables = [
  #   +        "DISPLAY",
  #            "WAYLAND_DISPLAY",
  #            "XDG_CURRENT_DESKTOP",
  #            "XDG_SESSION_TYPE",
  #   EOF
  # '';

  # patchPhase = ''
  #   patch -Np1 <<EOF
  #   diff --git a/resources/niri-session b/resources/niri-session
  #   index 85f6991..d54aa20 100755
  #   --- a/resources/niri-session
  #   +++ b/resources/niri-session
  #   @@ -38,4 +41,4 @@ systemctl --user --wait start niri.service
  #    systemctl --user start --job-mode=replace-irreversibly niri-shutdown.target
 
  #    # Unset environment that we've set.
  #   -systemctl --user unset-environment WAYLAND_DISPLAY XDG_SESSION_TYPE XDG_CURRENT_DESKTOP NIRI_SOCKET
  #   +systemctl --user unset-environment DISPLAY WAYLAND_DISPLAY XDG_SESSION_TYPE XDG_CURRENT_DESKTOP NIRI_SOCKET
  #   diff --git a/src/main.rs b/src/main.rs
  #   index b5576e8..08dafe0 100644
  #   --- a/src/main.rs
  #   +++ b/src/main.rs
  #   @@ -184,6 +184,9 @@ fn main() -> Result<(), Box<dyn std::error::Error>> {
  #        )
  #        .unwrap();
 
  #   +    // Set DISPLAY for children (to use xwayland-satellite)
  #   +    env::set_var("DISPLAY", ":0");
  #   +
  #        // Set WAYLAND_DISPLAY for children.
  #        let socket_name = &state.niri.socket_name;
  #        env::set_var("WAYLAND_DISPLAY", socket_name);
  #   @@ -264,6 +267,7 @@ fn main() -> Result<(), Box<dyn std::error::Error>> {
 
  #    fn import_environment() {
  #        let variables = [
  #   +        "DISPLAY",
  #            "WAYLAND_DISPLAY",
  #            "XDG_CURRENT_DESKTOP",
  #            "XDG_SESSION_TYPE",
  #   EOF
  # '';

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
