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
          rev = "7e1e702a9adab000c794f07b9ec7d7650c6a9f10";
          hash = "sha256-lYp8MPF0zUntfcfjrWj+G+8Zcj/GJup3jrLdHY9b/Og=";
        };
        cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
          inherit src;
          hash = "sha256-sOD4vz3UJgq7EnjcQLwj6PLAd3wHKrv77ovvq7s/aeA=";
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
          "export CI=true\n"
          + lib.cleanup
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
