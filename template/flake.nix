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
      };

      # Allows to run a live preview server using "nix run .#live"
      apps = {
        live.type = "app";
        live.program = builtins.toString (pkgs.writeShellScript "entr-reload" ''
          ${self.packages.${system}.builder}

          ${lib.getExe pkgs.nodePackages.live-server} \
            --watch=resume.html --open=resume.html --wait=300 &

          printf "\n%s" resume.{toml,nix,json} |
            ${lib.getExe pkgs.xe} -s 'test -f "$1" && echo "$1"' |
            ${lib.getExe pkgs.entr} -p ${self.packages.${system}.builder}
        '');
      };
    })
    // {inherit inputs;};
}
