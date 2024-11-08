#!/bin/sh
set -e -u -o pipefail

tos_bat="$(wslpath -w $HOME)\\bin\\turnoffscreen.bat"
/mnt/c/Windows/System32/cmd.exe /c "$tos_bat" &> /dev/null
