{
  description = "Application packaged using poetry2nix";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.poetry2nix = {
    url = "github:nix-community/poetry2nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, poetry2nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        # see https://github.com/nix-community/poetry2nix/tree/master#api for more functions and examples.
        inherit (poetry2nix.legacyPackages.${system}) mkPoetryApplication;
        inherit (poetry2nix.legacyPackages.${system}) mkPoetryEnv;
        pkgs = nixpkgs.legacyPackages.${system};
        lib = pkgs.lib;
        stdenv = pkgs.stdenv;
        poetryOverrides = {};
        # poetryEnv = mkPoetryEnv {
        #   projectDir = ./.;
        #   overrides = poetryOverrides;
        #   preferWheels = true;
        # };
      in
      {
        # packages = rec {
        #   app = mkPoetryApplication {
        #     projectDir = self;
        #     overrides = poetryOverrides;
        #     preferWheels = true;
        #   };
        #   appEnv = app.dependencyEnv;
        #   default = self.packages.${system}.appEnv;
        # };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # poetryEnv
            # python310Packages.pandas
            # python310Packages.scrapy # hopefully 2.7.1 synced with poetry
          ];
          packages = [
            poetry2nix.packages.${system}.poetry
            pkgs.age
            pkgs.sops
            # pkgs.sqlitebrowser
          ];
          # shellHook = ''
          #   LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath [ pkgs.stdenv.cc.cc.lib ]};
          # '';
        };
      });
}
