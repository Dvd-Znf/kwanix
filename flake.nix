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
          komac
        ];
        text = builtins.concatStringsSep "\n" (builtins.map (lib.updateFromGithub) gh-manifests);
        excludeShellChecks = [ "SC2086" ];
      };

    };
}
