{
  repo = "digitalocean/doctl";
  targets = [
    "doctl-\${tag_name:1}-windows-386.zip"
    "doctl-\${tag_name:1}-windows-amd64.zip"
    "doctl-\${tag_name:1}-windows-arm64.zip"
  ];
}
