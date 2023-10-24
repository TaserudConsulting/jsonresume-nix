{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}: let
  pname = "jsonresume-theme-full";
  version = "unstable-2023-07-16";
in
  buildNpmPackage {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "jackkeller";
      repo = pname;
      rev = "66e3d0673db9b436e4fb7cdf5d9dc336d1f3a0a4";
      hash = "sha256-ZYAExajB2BUXf17fOYnLFEZAeKCnCnjwym/VO1k2yk8=";
    };

    npmDepsHash = "sha256-jqsrQaMth71kGk6NEyGgUbjVHhpXn2kIDi/T6tmbcZI=";
    dontNpmBuild = true;

    meta = {
      description = "Simple to the point theme for JSON Resume, based on the short theme.";
      homepage = "https://github.com/jackkeller/jsonresume-theme-full";
      license = lib.licenses.mit;
    };
  }
