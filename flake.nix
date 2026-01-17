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
              rev = "0554f01e566cb4327358cbe366bf0cfd8b62ccf0";
              hash = "sha256-Woh2NNCxQkiJH/9BJpykC3Fy+nf6Oh4Zgs3If4/pt8g=";
            };
            cargoDeps = rustPlatform.fetchCargoVendor {
              inherit src;
              hash = "sha256-YloeJgP4wDQ4JHn+Rw8pSm5Dsx1sdz/s1CLMj5LOZ5s=";
            };
          }))

        ];
        text = builtins.concatStringsSep "\n" (builtins.map (lib.updateFromGithub) gh-manifests);
        excludeShellChecks = [ "SC2086" ];
      };

    };
}
