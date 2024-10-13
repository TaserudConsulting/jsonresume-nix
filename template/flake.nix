{
  description = "Your personal jsonresume built with Nix";

  inputs.jsonresume-nix.url = "github:TaserudConsulting/jsonresume-nix";
  inputs.jsonresume-nix.inputs.flake-utils.follows = "flake-utils";
  inputs.flake-utils.url = "flake-utils";

  outputs = {
    jsonresume-nix,
    self,
    flake-utils,
    nixpkgs,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      lib = pkgs.lib;
    in {
      # Specify formatter package for "nix fmt ." and "nix fmt . -- --check"
      formatter = pkgs.alejandra;

      # Specify the builder package to use to build your resume, this
      # will decide which theme to use.
      #
      # To show available packaged themes:
      # nix flake show github:TaserudConsulting/jsonresume-nix
      #
      # If you miss a theme, consider opening a pull request :)
      packages = {
        builder = jsonresume-nix.packages.${system}.resumed-fullmoon;
        inherit (jsonresume-nix.packages.${system}) fmt-as-json;

        # Build production build
        #
        # This may need customizations, such as using the correct file
        # format and copying other resources (such as images).
        default = pkgs.runCommand "resume" {} ''
          ln -s ${./resume.nix} resume.nix
          HOME=$(mktemp -d) ${lib.getExe self.packages.${system}.builder}
          mkdir $out
          cp -v resume.html $out/index.html
          # Copy other resources such as images here...
        '';
      };

      # Allows to run a live preview server using "nix run .#live"
      apps = {
        live.type = "app";
        live.program = lib.getExe (jsonresume-nix.lib.${system}.buildLiveServer self.packages.${system}.builder);

        print.type = "app";
        print.program = lib.getExe (jsonresume-nix.lib.${system}.buildPrintToPdf {
          builderDerivation = self.packages.${system}.builder;
        });
      };
    })
    // {inherit inputs;};
}
