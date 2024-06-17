{ kernel, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "corefreq";
  version = "1.97";

  src = fetchFromGitHub {
    owner = "cyring";
    repo = "CoreFreq";
    rev = "3271cc9c227201514fc89f721a326f890840bcd8";
    sha256 = "sha256-Lqb/M1dh/WeIylvoR0i2/o29lS3oXFb2P70S0swtqZs=";
  };

  hardeningDisable = [ "pic" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;
  buildFlags = [ "KERNELDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" ];

  postPatch = ''
    sed -i '103s/modules/ccflags-y="$(ccflags-y)" modules/' Makefile
  '';

  installPhase = ''
    install -D build/corefreqk.ko $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/hwmon/corefreqk.ko

    mkdir -p $out/bin
    mv build/corefreqd build/corefreq-cli $out/bin
  '';
}
