{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}: let
  pname = "jsonresume-theme-stackoverflow";
  version = "2.0.2";
in
  buildNpmPackage {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "phoinixi";
      repo = pname;
      rev = "v${version}";
      hash = "sha256-8ACOuhGTWOC/pYdla7m6uKvw2TA6SBXuNlfMYsHUiyo=";
    };

    dontNpmBuild = true;
    npmDepsHash = "sha256-H3bVs5VmK5eEPvxF85E8v+vAkGQPDjWM+mEKOJ95RMw=";

    meta = {
      description = "Stack Overflow theme for JSON Resume";
      homepage = "https://github.com/phoinixi/jsonresume-theme-stackoverflow";
    };
  }
