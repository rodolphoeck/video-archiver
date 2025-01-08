#!/bin/sh

while true ; do
  echo "Running on $(date)"
  cd /downloads/channels || exit
  for dir in * ; do
    if [ -d "$dir" ] && [ "$dir" != "@eaDir" ]; then
      if [ -f "$dir/.channel" ]; then
            echo "Downloading $dir"
            cd "$dir" || exit
            yt-dlp -i -N 20 --cookies "$YT_COOKIES_PATH" --no-cache-dir --match-filter !is_live --no-playlist --download-archive ./.db -P 'temp:/tmp' -o '%(upload_date)s - %(channel)s - %(title)s [%(id)s].%(ext)s' "$(cat ./.channel)"
            cd ..
        else
            echo ".channel not found in directory: $dir"
        fi
    fi
  done
  cd /
  echo "Sleeping for 1 day on $(date)"
  sleep 1d
done
