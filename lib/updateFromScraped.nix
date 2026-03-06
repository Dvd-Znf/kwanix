{
  id,
  fetcher,
  autoreplace ? false,
  disabled ? false,
}:
if disabled then
  ""
else
  fetcher
  + ''
     komac update ${id} \
    --submit --urls \
    ''${urls[*]} \
    --version "''${version#v}" \
    ${if autoreplace then "--replace \"$(komac list-versions ${id} | head -n 1)\"" else ""} \
    & disown;
  ''
