# meh,
''
  package_identifier="Mozilla.Firefox.MSIX.Nightly"

  month_url="https://ftp.mozilla.org/pub/firefox/nightly/$(date +%Y)/$(date +%m)/"

  html_listing=$(curl -s "$month_url")

  latest_folder=$(echo "$html_listing" | grep -oP '/[0-9]{4}/[0-9]{2}/\K[0-9]{4}-[0-9]{2}-[0-9]{2}-[0-9]{2}-[0-9]{2}-[0-9]{2}-mozilla-central(?=/)' | sort -V | tail -n 1)

  build_url="''${month_url}''${latest_folder}/"

  html=$(curl -s "$build_url")

  installer_32=$(echo "$html" | grep -oP 'firefox-.*?\.win32\.installer\.msix' | head -n 1)
  installer_64=$(echo "$html" | grep -oP 'firefox-.*?\.win64\.installer\.msix' | head -n 1)
  installer_arm64=$(echo "$html" | grep -oP 'firefox-.*?\.win64-aarch64\.installer\.msix' | head -n 1)

  if [[ -z "$installer_32" || -z "$installer_64" || -z "$installer_arm64" ]]; then
      echo "Could not find all FF Nightly installers."
      exit 1
  fi

  firefox_version=$(echo "$installer_64" | grep -oP 'firefox-\K[0-9]+\.[0-9]+[a-z]?[0-9]*')

  short_version=$(echo "$firefox_version" | grep -oP '^[0-9]+')

  IFS='-' read -r year month day hour _ <<< "$latest_folder"
  date_code="''${year:2:2}''${month}"
  time_code="$((10#$day * 100 + 10#$hour))"

  full_version="''${short_version}.''${date_code}.''${time_code}.0"

  url_32="''${build_url}''${installer_32}"
  url_64="''${build_url}''${installer_64}"
  url_arm64="''${build_url}''${installer_arm64}"

  release_notes_url="https://www.firefox.com/en-US/firefox/''${firefox_version}/releasenotes/"

  komac update "$package_identifier" --submit \
      --version "$full_version" \
      --urls "$url_32" "$url_64" "$url_arm64" \
      --release-notes-url "$release_notes_url" & disown;
''
