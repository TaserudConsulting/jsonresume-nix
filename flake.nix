{
  description = "jsonresume-nix";

  inputs = {
    flake-utils.url = "flake-utils";
  };

  outputs = {
    self,
    flake-utils,
    nixpkgs,
    ...
  }:
    {
      # Flake outputs
    }
    // flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      # Specify formatter package for "nix fmt ." and "nix fmt . -- --check"
      formatter = pkgs.alejandra;

      # Set up nix develop shell environment
      devShells.default = pkgs.mkShell {
        buildInputs = [
          pkgs.resumed
          pkgs.nodejs
        ];
      };

      packages = {
        resumed = pkgs.resumed;
        jsonresume-theme-macchiato = pkgs.callPackage ./themes/jsonresume-theme-macchiato {};
        jsonresume-theme-stackoverflow = pkgs.callPackage ./themes/jsonresume-theme-stackoverflow {};
      };
    });
}
