{
  repo = "syncthing/syncthing";
  targets = [
    "syncthing-windows-386-$tag_name.zip"
    "syncthing-windows-amd64-$tag_name.zip"
    "syncthing-windows-arm64-$tag_name.zip"
  ];
}
