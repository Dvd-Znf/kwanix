{
  description = "Komac Wrapper As a nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      lib = import ./lib;
      gh-manifests = map (manifest: import manifest.path // { id = manifest.id; }) (
        builtins.map (n: {
          path = toString ./winget-pkgs/fromGithub + "/${n}";
          id = nixpkgs.lib.removeSuffix ".nix" n;
        }) (builtins.attrNames (builtins.readDir ./winget-pkgs/fromGithub))
      );
      web-manifests = map (manifest: import manifest.path // { id = manifest.id; }) (
        builtins.map (n: {
          path = toString ./winget-pkgs/fromWebScraped + "/${n}";
          id = nixpkgs.lib.removeSuffix ".nix" n;
        }) (builtins.attrNames (builtins.readDir ./winget-pkgs/fromWebScraped))
      );
    in
    {
      packages.x86_64-linux.komac = pkgs.komac.overrideAttrs (rec {
        src = pkgs.fetchFromGitHub {
          owner = "Dvd-Znf";
          repo = "Komac";
          rev = "a887b4b1f8b252893346a94ab2e4c5213726768a";
          hash = "sha256-joPF92qeK+L+JfPcILbfQQXXOL11hiPDt4JNXouPCK0=";
        };
        cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
          inherit src;
          hash = "sha256-bmesjvXX++Kn47E+KpHKYF/lpIcNXtVzH4s/AMHDmhc=";
        };
      });
      packages.x86_64-linux.default = self.packages.x86_64-linux.kwanix;
      packages.x86_64-linux.kwanix = pkgs.writeShellApplication {
        name = "kwanix";
        runtimeInputs =
          with pkgs;
          [
            curl
            jq
          ]
          ++ [ self.packages.x86_64-linux.komac ];
        text =
          lib.cleanup
          + builtins.concatStringsSep "\n" (
            (builtins.map (lib.updateFromGithub) gh-manifests)
            ++ (builtins.map (lib.updateFromScraped) web-manifests)
          );
        excludeShellChecks = [
          "SC2086"
          "SC2048" # forces "${array[@]}" (with quotes), but we want that behaviour >:3c
        ];
      };

    };
}
