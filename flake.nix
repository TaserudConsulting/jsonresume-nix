{
  description = "jsonresume-nix";

  inputs.flake-utils.url = "flake-utils";

  outputs = {
    self,
    flake-utils,
    nixpkgs,
    ...
  } @ inputs:
    {
      # Flake outputs
      templates.default = {
        path = ./template;
        description = "Template to build jsonresume with nix";
      };
    }
    // flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      lib = pkgs.lib;
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

      # Check output to run checks for all themes
      checks.themes = let
        builderAttrs =
          lib.filterAttrs
          (name: _: lib.strings.hasPrefix "resumed-" name)
          self.packages.${system};
      in
        pkgs.stdenv.mkDerivation {
          name = "themes-checks";
          src = ./template;

          buildPhase =
            ''
              cp resume.sample.json resume.json
            ''
            + (builtins.concatStringsSep "\n\n"
              (lib.attrValues (lib.mapAttrs
                (name: value: ''
                  # Build using builder ${name}
                  ${lib.getExe value}
                  mv resume.html ${name}.html
                '')
                builderAttrs)));

          installPhase =
            ''
              mkdir $out
            ''
            + (builtins.concatStringsSep "\n\n"
              (lib.attrValues (
                lib.mapAttrs
                (name: _: ''
                  mv ${name}.html $out
                '')
                builderAttrs
              )));
        };

      lib = {
        buildLiveServer = builderDerivation:
          pkgs.writeShellApplication {
            name = "live-entr-reload-server";
            runtimeInputs = [
              pkgs.entr
              pkgs.nodePackages.live-server
              pkgs.xe

              # Include the desired builders program that cointains `resumed-render`
              builderDerivation
            ];
            text = ''
              resumed-render

              live-server --watch=resume.html --open=resume.html --wait=300 &

              # We want to not expand $1 in the xe argument
              # shellcheck disable=SC2016
              printf "\n%s" resume.{toml,nix,json} |
                xe -s 'test -f "$1" && echo "$1"' |
                entr -p resumed-render
            '';
          };

        buildPrintToPdf = {
          builderDerivation,
          format ? "A4",
        }:
          pkgs.writeShellApplication {
            name = "print-to-pdf";
            runtimeInputs = [
              pkgs.puppeteer-cli
              pkgs.nodePackages.live-server

              # Include the desired builders program that cointains `resumed-render`
              builderDerivation
            ];
            text = ''
              PORT=$(shuf -i 2000-65000 -n 1)

              resumed-render

              live-server --host=127.0.0.1 --port="$PORT" --wait=300 --no-browser &
              LIVE_SERVER_PID=$!

              puppeteer print "http://127.0.0.1:$PORT/resume.html" resume.pdf --format ${format}

              kill "$LIVE_SERVER_PID"
            '';
          };

        buildThemeBuilder = themeName: let
          themePkg = pkgs.callPackage ./themes/jsonresume-theme-${themeName} {};
        in
          pkgs.writeShellApplication {
            name = "resumed-render";
            runtimeInputs = [
              self.packages.${system}.fmt-as-json
              pkgs.resumed
            ];
            text = ''
              # Convert resume.nix to resume.json
              fmt-as-json

              # Render resume.json
              resumed render \
                --theme ${themePkg}/lib/node_modules/jsonresume-theme-${themeName}/index.js
            '';
          };
      };

      # Expose packages for themes and resumed used
      packages = let
        # Shorthand for the buildThemeBuilder from lib
        inherit (self.lib.${system}) buildThemeBuilder;
      in {
        # Resumed package used
        inherit (pkgs) resumed;

        # Themes
        resumed-elegant = buildThemeBuilder "elegant";
        resumed-full = buildThemeBuilder "full";
        resumed-fullmoon = buildThemeBuilder "fullmoon";
        resumed-kendall = buildThemeBuilder "kendall";
        resumed-macchiato = buildThemeBuilder "macchiato";
        resumed-stackoverflow = buildThemeBuilder "stackoverflow";

        fmt-as-json = pkgs.writeShellApplication {
          name = "fmt-as-json";
          runtimeInputs = [
            pkgs.findutils
            pkgs.jq
            pkgs.nix
            pkgs.resumed
            pkgs.yq-go
            pkgs.dhall-json
          ];
          text = ''
            set -eou pipefail

            yamlresume="$(find . \( -name 'resume.yaml' -o -name 'resume.yml' \) | head -1 || echo)"

            if test -e "./resume.nix"; then
              echo "Converting ./resume.nix to ./resume.json" 1>&2
              nix-instantiate --eval -E 'builtins.toJSON (import ./resume.nix)' \
                | jq -r \
                | jq > resume.json
            elif test -e "./resume.toml"; then
              echo "Converting ./resume.toml to ./resume.json" 1>&2
              nix-instantiate --eval -E 'builtins.toJSON (builtins.fromTOML (builtins.readFile ./resume.toml))' \
                | jq -r \
                | jq > resume.json
            elif test -e "./resume.dhall"; then
              echo "Converting ./resume.dhall to ./resume.json" 1>&2
              dhall-to-json --file ./resume.dhall --output resume.json
            elif [[ $yamlresume != "" ]]; then
              echo "Converting $yamlresume to ./resume.json" 1>&2
              yq -o=json '.' "$yamlresume" > resume.json
            elif test -e "./resume.json"; then
              echo "Found ./resume.json, not touching it" 1>&2
            else
              echo "No resume of any supported format found, currently looking for" 1>&2
              echo "any of ./resume.(nix|toml|json|yaml|yml|dhall)"                 1>&2
              exit 2
            fi

            echo "Running validation of ./resume.json" 1>&2
            resumed validate
          '';
        };
      };
    })
    // {inherit inputs;};
}
