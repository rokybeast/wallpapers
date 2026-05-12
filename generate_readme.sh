#!/usr/bin/env bash

# Usage: ./generate_readme.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
README="$SCRIPT_DIR/README.md"
COLUMNS=3  # no. of columns in table

# collect image files
mapfile -t images < <(find "$SCRIPT_DIR" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.gif' -o -iname '*.webp' -o -iname '*.bmp' -o -iname '*.svg' \) | sort)

if [[ ${#images[@]} -eq 0 ]]; then
  echo "No image files found in $SCRIPT_DIR"
  exit 1
fi

# start writing the readme file
{
  echo "# 🖼️ Wallpapers"
  echo ""
  echo "> A collection of **${#images[@]}** wallpapers."
  echo ""

  # Table header
  header=""
  separator=""
  for ((c = 1; c <= COLUMNS; c++)); do
    header+="| Preview | Name "
    separator+="| :---: | :--- "
  done
  echo "${header}|"
  echo "${separator}|"

  # table rows
  idx=0
  total=${#images[@]}
  while ((idx < total)); do
    row=""
    for ((c = 0; c < COLUMNS; c++)); do
      i=$((idx + c))
      if ((i < total)); then
        filename="$(basename "${images[$i]}")"
        # url-encode spaces in the filename for the markdown link
        encoded="${filename// /%20}"
        row+="| <img src=\"${encoded}\" width=\"300\"/> | \`${filename}\` "
      else
        row+="| | "
      fi
    done
    echo "${row}|"
    idx=$((idx + COLUMNS))
  done

  echo ""
  echo "---"
  echo ""
  echo "*auto-generated on $(date '+%Y-%m-%d %H:%M:%S').*"
} > "$README"

echo "[SUCCESS]: README.md generated with ${#images[@]} wallpapers."
