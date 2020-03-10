#!/usr/bin/env bash

# close the apps

osascript -e "quit app \"Google Chrome\""
osascript -e "quit app \"Brave\ Browser\""
osascript -e "quit app \"Safari\""

umount -f /Volumes/ramdisk

# Browsers
mkdir -p ~/Library/Caches/Google/Chrome/Default
mkdir -p ~/Library/Caches/BraveSoftware/Brave-Browser/Default
mkdir -p ~/Library/Caches/com.apple.Safari
# Hopefully nobody edited idea properties file - deleting the items we add
