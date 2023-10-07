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
      templates.default = {
        path = ./template;
        description = "Template to build jsonresume with nix";
      };
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

      # Expose packages for themes and resumed used
      packages = let
        buildThemeBuilder = themeName: let
          themePkg = pkgs.callPackage ./themes/jsonresume-theme-${themeName} {};
        in
          pkgs.writeScript "resumed-render-wrapped-${themeName}-${themePkg.version}" ''
            #!${pkgs.stdenv.shell}
            set -eou pipefail

            ${pkgs.resumed}/bin/resumed validate

            ${pkgs.resumed}/bin/resumed render \
              --theme ${themePkg}/lib/node_modules/jsonresume-theme-${themeName}/index.js
          '';
      in {
        resumed = pkgs.resumed;
        resumed-elegant = buildThemeBuilder "elegant";
        resumed-fullmoon = buildThemeBuilder "fullmoon";
        resumed-kendall = buildThemeBuilder "kendall";
        resumed-macchiato = buildThemeBuilder "macchiato";
        resumed-stackoverflow = buildThemeBuilder "stackoverflow";
      };
    });
}
