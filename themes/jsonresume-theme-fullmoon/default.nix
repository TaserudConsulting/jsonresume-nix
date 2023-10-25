{
  buildNpmPackage,
  fetchFromGitHub,
}: let
  pname = "jsonresume-theme-fullmoon";
  version = "0.1.2";
in
  buildNpmPackage {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "IsFilimonov";
      repo = pname;
      rev = "v${version}";
      hash = "sha256-6zdqIE/DpuLhlQ6OFrOfNGu7Vq8w+0OAcMYCNQXD1xY=";
    };

    npmDepsHash = "sha256-1DIxCiUWF46YSCjvIzrXwz0w6+TwdXndUgb0Pgd3kHI=";
    dontNpmBuild = true;

    meta = {
      description = "A fullm🌑🌕n template for JSON resume";
      homepage = "https://github.com/IsFilimonov/jsonresume-theme-fullmoon";
    };
  }
