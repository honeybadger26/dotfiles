#!/bin/sh
set -e -u -o pipefail

# Shut down PC after a certain number of hours

delay_hours=$1
delay_seconds=$((delay_hours * 60 * 60))

~/bin/turnoffscreen.sh
sleep $delay_seconds
/mnt/c/Windows/System32/shutdown.exe -s
