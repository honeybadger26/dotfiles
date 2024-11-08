#!/bin/sh
set -e -u -o pipefail

# Rename files to the date that they were created or last modified.

dir="$1"
nc="\033[0m"
grey="\033[30m"
green="\033[32m"
blue="\033[34m"
format_str='%Y.%m.%d-%H.%M.%S'
cd $dir

for filename in *; do
  datetime=$(exiftool -d $format_str -DateTimeOriginal -S -s "$filename")
  [ "$datetime" = "" ] && datetime=$(exiftool -d $format_str -CreationDate -S -s "$filename")
  [ "$datetime" = "" ] && datetime=$(exiftool -d $format_str -CreateDate -S -s "$filename")
  [ "$datetime" = "" ] && datetime=$(exiftool -d $format_str -FileModifyDate -S -s "$filename")

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
  echo -e "${filename} ${blue}->${nc} ${green}${new_filename}${nc}"
done
