# jsonresume-nix
Build and deploy your résumé using [Nix](https://nixos.org/) and
[jsonresume](https://jsonresume.org/) in a reproducible way. We
provide some themes and make it easy to add more themes (pull requests
are welcome).

We have a template to easily deploy it GitHub pages or using their
hosted service where the JSON schema is hosted as a GitHub gist.

We also supports transforming into the JSON schema from other
languages so you aren't used to a raw JSON format.

Formats supported:

- Nix (that gets evaluated into the JSON schema)
- Dhall (that gets evaluated into the JSON schema)
- TOML (that gets parsed into the JSON schema)
- YAML (.yml or .yaml, that gets converted into the JSON schema)
- JSON (just the original JSON format)

## Getting started

Create your own `resume` repository and run

    nix flake init -t github:TaserudConsulting/jsonresume-nix

to clone the template to use this flake.

In there you get a `builder` that determines the theme to use. To
build it you can just run `nix build .#builder` and execute the result
like `./result` which will build `resume.nix` into a HTML output. Note
that it's required that this `flake.nix` is part of a git repository
and that you at least stage the `flake.nix` file to be able to build.

To change the theme used you'd just change the `defaultPackage` used,
to list available packages you just run:

    nix flake show github:TaserudConsulting/jsonresume-nix

Then nix will list available theme wrappers.

### Live preview when building your résumé

If you want a live preview of how the final result will look while
filling out your résumé schema file, run the following command:

    nix run .#live

## [TODO] Things to do

- [ ] Wrapper script to package themes
- [ ] Wrapper script to update themes
- [ ] Wrapper script to test themes
- [X] Expose themes as packages in flake
- [X] Expose resumed as package in flake
- [X] Add a flake check that tests all themes
- [ ] Add a flake output to test end users résumés and themes builds
      as flake checks
- [ ] Add a flake output to use as flake init for end users résumés
      repositories
- [ ] Add CI to update flake and themes

## Finding and testing more themes before packaging them

<https://www.npmjs.com/search?q=jsonresume-theme>

Find the theme name, then run `npm install
jsonresume-theme-THEMENAME`, this should install the theme in your
local directory (given that you have `nodejs` available, use
`nix-shell` for this).

Then you should be able to use `nix-shell` to make `resumed` available
as well and test the theme by running:

    resumed render --theme $(pwd)/node_modules/jsonresume-theme-THEMENAME/index.js

The full path seems to be super important here. If this works you can
attempt to package it and expose it in the flake.
