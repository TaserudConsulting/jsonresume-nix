{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}: let
  pname = "jsonresume-theme-kendall";
  version = "0.2.0";
in
  buildNpmPackage {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "LinuxBozo";
      repo = pname;
      rev = "90438746fd64fc8184f439d5731a7d118660ab7a";
      hash = "sha256-BBtU55k1J7M5nfhgXkmY69zx+ffnhlFiNbNvp8rUeBM=";
    };

    npmDepsHash = "sha256-n3waeDunWnhGrVAliWwcJ3QKb2Oy0K+5rt+aZsmSmuA=";
    dontNpmBuild = true;

    meta = {
      description = "A theme for jsonresume";
      homepage = "https://github.com/LinuxBozo/jsonresume-theme-kendall";
    };
  }
