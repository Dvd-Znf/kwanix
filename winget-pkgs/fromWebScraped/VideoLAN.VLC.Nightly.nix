{
  autoreplace = true;
  fetcher = ''
    base_x64="https://artifacts.videolan.org/vlc/nightly-win64/"
    base_arm="https://artifacts.videolan.org/vlc/nightly-win64-arm-llvm/"

    latest_x64_folder=$(curl -s "$base_x64" | grep -oP '(?<=href=")[0-9]{8}-[0-9]{4}(?=/)' | sort -V | tail -n 1)
    latest_arm_folder=$(curl -s "$base_arm" | grep -oP '(?<=href=")[0-9]{8}-[0-9]{4}(?=/)' | sort -V | tail -n 1)

    html_x64=$(curl -s "''${base_x64}''${latest_x64_folder}/")
    html_arm=$(curl -s "''${base_arm}''${latest_arm_folder}/")

    url_x64=$(echo "$html_x64" | grep -oP 'vlc-.*?\.msi' | head -n 1)
    url_arm=$(echo "$html_arm" | grep -oP 'vlc-.*?\.msi' | head -n 1)

    if [[ -z "$url_x64" || -z "$url_arm" ]]; then
        echo "Could not find all VLC Nightly installers."
        exit 1
    fi

    url_x64="''${base_x64}''${latest_x64_folder}/''${url_x64}"
    url_arm="''${base_arm}''${latest_arm_folder}/''${url_arm}"

    vlc_version=$(echo "$url_x64" | grep -oP 'vlc-\K[0-9]+\.[0-9]+\.[0-9]+')

    date_code=$(echo "$latest_x64_folder" | cut -d'-' -f1)

    version="''${vlc_version}.0-nightly''${date_code}"
    urls=( "$url_x64|x64" "$url_arm|arm64" )
  '';
}
