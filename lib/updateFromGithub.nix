{
  id,
  repo,
  targets,
  autoreplace ? false, # todo unused
}:
''
  tag_name=$(curl -s https://api.github.com/repos/${repo}/releases/latest | jq -r '.tag_name')
  download_url=https://github.com/${repo}/releases/download/"$tag_name"

  komac update --submit --urls \
  ${builtins.concatStringsSep "\n" (map (target: "\"$download_url/\"" + target + " \\") targets)}
  --version "$tag_name" \
  ${id} & disown;
''
