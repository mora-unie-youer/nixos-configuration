{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage {
  pname = "wl-gammarelay-rs";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "Givralix";
    repo = "wl-gammarelay-rs";
    rev = "07a335bb9910d366eb5ca6f4e66bbd550deb1b08";
    hash = "sha256-3cAotyPD88e7nK4UFHYJc87XJCTw7Y+ilhMdefICIoE=";
  };

  cargoHash = "sha256-TDP5RC7B7/ldpK22WsmXd6fSl2rHtvG0hP9NYzoEVYo=";

  meta = {
    description = "A simple program that provides DBus interface to control display temperature and brightness under wayland without flickering";
    homepage = "https://github.com/MaxVerevkin/wl-gammarelay-rs";
    license = lib.licenses.gpl3Plus;
    mainProgram = "wl-gammarelay-rs";
    maintainers = with lib.maintainers; [quantenzitrone];
    platforms = lib.platforms.linux;
  };
}
