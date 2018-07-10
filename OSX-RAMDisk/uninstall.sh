#!/usr/bin/env bash

# close the apps

osascript -e "quit app \"Google Chrome\""
osascript -e "quit app \"Chrome\ Canary\""
osascript -e "quit app \"Safari\""
osascript -e "quit app \"IntelliJ IDEA 14\""

umount -f /Volumes/ramdisk

# Browsers
mkdir -p ~/Library/Caches/Google/Chrome/Default
mkdir -p ~/Library/Caches/Google/Chrome\ Canary/Default
mkdir -p ~/Library/Caches/com.apple.Safari
# Hopefully nobody edited idea properties file - deleting the items we add
# todo add sed statements to remove lines "smarter"
head --lines=-2 /Applications/IntelliJ\ IDEA\ 14.app/Contents/bin/idea.properties /Applications/IntelliJ\ IDEA\ 14.app/Contents/bin/idea.properties
