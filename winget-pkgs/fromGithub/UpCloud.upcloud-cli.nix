{
  repo = "UpCloudLtd/upcloud-cli";
  targets = [
    "upcloud-cli_\${tag_name:1}_windows_x86_64.zip"
    "upcloud-cli_\${tag_name:1}_windows_arm64.zip"
  ];
}
