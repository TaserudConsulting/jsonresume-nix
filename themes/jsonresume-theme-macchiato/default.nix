{
  buildNpmPackage,
  fetchFromGitHub,
  fetchpatch,
  python3,
}: let
  pname = "jsonresume-theme-macchiato";
  version = "2021-02-20";
in
  buildNpmPackage {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "biosan";
      repo = pname;
      rev = "c783186d31c88924b7808bf65a892cef233099c4";
      hash = "sha256-ssqZBlVnEtOSldDrEAPsmTxAdGozeABdt98xSXv0Fe0=";
    };

    npmDepsHash = "sha256-yK7Yp2580XiGv1nHmyBnnF7dLlADOP8NWLvuzAMclOo=";

    patches = [
      (fetchpatch {
        url = "https://patch-diff.githubusercontent.com/raw/biosan/jsonresume-theme-macchiato/pull/22.patch";
        hash = "sha256-sq5gOiY35uJF7k0Hxx19VMh1Gn9i2lWAlbNAgqBboHM=";
      })
    ];

    nativeBuildInputs = [python3];
    dontNpmBuild = true;
    PUPPETEER_SKIP_CHROMIUM_DOWNLOAD = 1;

    meta = {
      description = "Simple JSONResume theme (based on Caffeine theme) ☕️+🥛";
      homepage = "https://github.com/biosan/jsonresume-theme-macchiato";
    };
  }
