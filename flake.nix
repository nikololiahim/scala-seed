{
  description = "A flake for getting started with Scala.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    let
      supportedSystems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
        "x86_64-darwin"
      ];
    in
    flake-utils.lib.eachSystem supportedSystems (
      system:
      let
        pkgs = import nixpkgs {
          system = system;
          config.allowUnfree = false;
        };

        makeShell =
          p:
          p.mkShell {
            buildInputs = with p; [
              nixfmt-rfc-style
              nixd
              jdk
              scala-cli
              scalafmt
            ];
          };
      in
      {
        devShells = {
          default = makeShell pkgs;
        };

        formatter = pkgs.nixfmt-rfc-style;
      }
    );
}
