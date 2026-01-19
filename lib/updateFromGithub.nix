{
  id,
  repo,
  targets,
  autoreplace ? false,
}:
''
  tag_name=$(curl -s https://api.github.com/repos/${repo}/releases/latest | jq -r '.tag_name')
  download_url=https://github.com/${repo}/releases/download/"$tag_name"

  komac update ${id} \ 
  --submit --urls \
  ${builtins.concatStringsSep "\n" (map (target: "\"$download_url/\"" + target + " \\") targets)}
  --version "''${tag_name#v}" \
  ${if autoreplace then "--replace $(komac list-versions ${id} | head -n 1)" else ""} \
  & disown;
''
