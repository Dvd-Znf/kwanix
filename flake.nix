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
      web-manifests = map (manifest: import manifest) (
        builtins.map (n: toString ./winget-pkgs/fromWebScraped + "/${n}") (
          builtins.attrNames (builtins.readDir ./winget-pkgs/fromWebScraped)
        )
      );
    in
    {
      packages.x86_64-linux.default = self.packages.x86_64-linux.kwanix;
      packages.x86_64-linux.kwanix = pkgs.writeShellApplication {
        name = "kwanix";
        runtimeInputs = with pkgs; [
          curl
          jq
          (komac.overrideAttrs (rec {
            src = fetchFromGitHub {
              owner = "Dvd-Znf";
              repo = "Komac";
              rev = "3159ef92d9739ed9f2acd0aca9cada27fb269103";
              hash = "sha256-/Uj6gSPbGzU2rrI0/iNxfgftufTQSsOQh+erE48TVpE=";
            };
            cargoDeps = rustPlatform.fetchCargoVendor {
              inherit src;
              hash = "sha256-YloeJgP4wDQ4JHn+Rw8pSm5Dsx1sdz/s1CLMj5LOZ5s=";
            };
          }))

        ];
        text = builtins.concatStringsSep "\n" (
          (builtins.map (lib.updateFromGithub) gh-manifests) ++ web-manifests
        );
        excludeShellChecks = [ "SC2086" ];
      };

    };
}
