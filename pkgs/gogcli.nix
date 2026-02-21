{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule {
  pname = "gogcli";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "steipete";
    repo = "gogcli";
    rev = "v0.11.0";
    hash = "sha256-hJU40ysjRx4p9SWGmbhhpToYCpk3DcMAWCnKqxHRmh0=";
  };

  vendorHash = "sha256-WGRlv3UsK3SVBQySD7uZ8+FiRl03p0rzjBm9Se1iITs=";

  # Tests require OAuth network access, which is unavailable in the Nix sandbox
  doCheck = false;

  meta = {
    description = "Unified CLI for Google Workspace (Gmail, Calendar, Drive, etc.)";
    homepage = "https://github.com/steipete/gogcli";
    license = lib.licenses.mit;
    mainProgram = "gogcli";
  };
}
