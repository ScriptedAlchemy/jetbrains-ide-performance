#!/usr/bin/env bash

[ -f ~/Library/LaunchAgents/OSXRamDisk.plist ] && launchctl unload -w ~/Library/LaunchAgents/OSXRamDisk.plist
[ -f /usr/local/bin/startupRAMDiskandCacheMover.sh ] && rm -f /usr/local/bin/startupRAMDiskandCacheMover.sh
[ -f ~/Library/LaunchAgents/OSXRamDisk.plist ] && rm -f ~/Library/LaunchAgents/OSXRamDisk.plist
[ -h ~/Library/Caches/Google/Chrome/Default ] && bash -c "rm -f ~/Library/Caches/Google/Chrome/Default; mkdir ~/Library/Caches/Google/Chrome/Default"

# close the apps

osascript -e "quit app \"Google Chrome\""
osascript -e "quit app \"Safari\""
osascript -e "quit app \"WebStorm\""

umount -f ~/ramdisk

# Browsers
mkdir -p ~/Library/Caches/Google/Chrome/Default
mkdir -p ~/Library/Caches/com.apple.Safari
