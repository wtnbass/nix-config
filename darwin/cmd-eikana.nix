{ stdenv, fetchzip }:

stdenv.mkDerivation {
  pname = "cmd-eikana";
  version = "2.4.2";

  src = fetchzip {
    url = "https://github.com/dominion525/cmd-eikana/releases/download/v2.4.2/cmd-eikana-v2.4.2-arm64.zip";
    hash = "sha256-IU1MmyieNMo1+SmzirhZoOZtohUgHwXL+Nk6k05SS24=";
  };

  installPhase = ''
    mkdir -p "$out/Applications"
    cp -a . "$out/Applications/⌘英かな.app"
  '';
}
