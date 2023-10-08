{
  description = "Your personal jsonresume built with Nix";

  inputs = {
    jsonresume-nix.url = "github:TaserudConsulting/jsonresume-nix";
    jsonresume-nix.inputs.flake-utils.follows = "flake-utils";

    flake-utils.url = "flake-utils";
  };

  outputs = {
    jsonresume-nix,
    self,
    flake-utils,
    nixpkgs,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      # Specify formatter package for "nix fmt ." and "nix fmt . -- --check"
      formatter = pkgs.alejandra;

      # Specify default package to use to build your resume, this will
      # decide which theme to use.
      #
      # To show available packaged themes:
      # nix flake show github:TaserudConsulting/jsonresume-nix
      #
      # If you miss a theme, consider opening a pull request :)
      packages = {
        default = jsonresume-nix.packages.${system}.resumed-fullmoon;
        inherit (jsonresume-nix.packages.${system}) nix-to-json;
      };
    });
}
