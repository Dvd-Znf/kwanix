{
  repo = "luolangaga/tubatools";
  targets = [
    "TubaWinUi3_Setup_\${tag_name:1}_x86.exe"
    "TubaWinUi3_Setup_\${tag_name:1}_x64.exe"
    "TubaWinUi3_Setup_\${tag_name:1}_arm64.exe"
  ];
}
