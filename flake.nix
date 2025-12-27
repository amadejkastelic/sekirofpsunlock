{
  description = "Linux patcher for Sekiro that removes FPS and resolution limitations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages = {
          default = pkgs.stdenv.mkDerivation {
            pname = "sekirofpsunlock";
            version = "0.2.3";

            src = ./.;

            nativeBuildInputs = with pkgs; [
              meson
              ninja
            ];
          };
        };

        devShells.default = pkgs.mkShell {
          inputsFrom = [ self.packages.${system}.default ];

          packages = with pkgs; [
            # Build tools
            meson
            ninja
            pkg-config

            # Development tools
            clang-tools
            gdb
            valgrind
            clang
          ];
        };
      }
    );
}
