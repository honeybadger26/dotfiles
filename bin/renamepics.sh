#!/bin/bash

set -e -u -o pipefail

# Rename files to the date that they were created or last modified.

cd $1
readarray -d '' files < <(find . -maxdepth 1 -type f -print0)
total=${#files[@]}

if [ "$total" -eq 0 ]; then
  echo "Error: No files found"
  exit 1
fi

FORMAT_STR='%Y.%m.%d-%H.%M.%S'
GRAY='\033[2m'
YELLOW='\033[33m'
BOLD='\033[1m'
RESET='\033[0m'

echo -e "${YELLOW}WARNING:${RESET} This script will rename all files in ${BOLD}$(pwd)${RESET}"
read -p "Continue? (y/N): " -n 1 response
if [[ "$response" != "y" ]]; then
  exit 1
fi
echo ""

for i in "${!files[@]}"; do
  idx=$((i+1))
  filename=${files[i]}

  datetime=$(exiftool -d $FORMAT_STR -DateTimeOriginal -S -s "$filename")
  [ "$datetime" = "" ] && datetime=$(exiftool -d $FORMAT_STR -CreationDate -S -s "$filename")
  [ "$datetime" = "" ] && datetime=$(exiftool -d $FORMAT_STR -CreateDate -S -s "$filename")
  [ "$datetime" = "" ] && datetime=$(exiftool -d $FORMAT_STR -FileModifyDate -S -s "$filename")

  # This is based off time modified. Less reliable but doesn't require installing exiftool
  # datetime=$(stat -c %y "$f" | sed -e 's/ +1100//g' -e 's/\.000000000//g' -e 's/-/\./g' -e 's/:/\./g' -e 's/ /-/g')

  extension="${filename##*.}"
  new_filename="${datetime}.${extension}"

  while [ -f "$new_filename" ]; do
    # Generate a random string of numbers and letters
    random_str=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 20 ; echo '')
    new_filename="${datetime}_${random_str}.${extension}"
  done

  mv "$filename" "$new_filename"
  echo -e "(${idx}/${total}) ${GRAY}${filename#./}${RESET} » ${BOLD}${new_filename}${RESET}"
done
