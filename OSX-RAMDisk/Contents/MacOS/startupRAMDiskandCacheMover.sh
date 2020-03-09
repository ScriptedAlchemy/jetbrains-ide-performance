#!/usr/bin/env bash

set -x

#
# Copyright Zafar Khaydarov
#
# This is about to create a RAM disk in OS X and move the apps caches into it
# to increase performance of those apps. Performance gain is very significant,
# particularly for browsers and especially for IDEs like IntelliJ Idea.
#
# Drawbacks and risks are that if RAM disk becomes full - performance will degrade
# significantly - huge amount of paging will happen.
#
# USE AT YOUR OWN RISK. PLEASE NOTE IT WILL NOT CHECK FOR CORRUPTED FILES
# IF YOUR RAM IS BROKEN - DO NOT USE IT.
#

# The RAM amount you want to allocate for RAM disk. One of
# 1024 2048 3072 4096 5120 6144 7168 8192
# By default will use 1/4 of your RAM

ramfs_size_mb=$(sysctl hw.memsize | awk '{print $2;}')
ramfs_size_mb=$((ramfs_size_mb/1024/1024/2))

mount_point=/Users/${USER}/ramdisk
ramfs_size_sectors=$((ramfs_size_mb*1024*1024/512))
ramdisk_device=$(hdid -nomount ram://${ramfs_size_sectors} | xargs)
USERRAMDISK="${mount_point}"

MSG_MOVE_CACHE=". Do you want me to move its cache? Note: It will close the app."
MSG_PROMPT_FOUND="I found "

#
# Checks for the user response.
#
user_response()
{
   echo -ne "$@" "[Y/n]  "
   read -r response

   case ${response} in
      [yY][eE][sS]|[yY]|"")
         true
         ;;
      [nN][oO]|[nN])
         false
         ;;
      *)
         user_response "$@"
         ;;
   esac
}

#
# Closes passed as arg app by name
#
close_app()
{
   osascript -e "quit app \"${1}\""
}

#
# Creates RAM Disk.
#
mk_ram_disk()
{
   # unmount if exists and mounts if doesn't
   umount -f "${mount_point}"
   newfs_hfs -v 'ramdisk' "${ramdisk_device}"
   mkdir -p "${mount_point}"
   mount -o noatime -t hfs "${ramdisk_device}" "${mount_point}"

   echo "created RAM disk."
   # Hide RAM disk - we don't really need it to be annoiyng in finder.
   # comment out should you need it.
   # hide_ramdisk
   # echo "RAM disk hidden"
}

# adds rsync to be executed each 5 min for current user
add_rsync_to_cron()
{
   #todo fixme
   crontab -l | { cat; echo "30 * * * * rsync"; } | crontab -
}

# Open an application
open_app()
{
   osascript -e "tell app \"${1}\" to activate"
}

# Hide RamDisk directory
hide_ramdisk()
{
   /usr/bin/chflags hidden "${mount_point}"
}

# Checks that we have
# all required utils before proceeding
check_requirements()
{
   hash rsync 2>/dev/null || { echo >&2 "No rsync has been found.  Aborting. If you use brew install using: 'brew install rsync'"; exit 1; }
   hash newfs_hfs 2>/dev/null || { echo >&2 "No newfs_hfs has been found.  Aborting."; exit 1; }
}

#
# Check existence of the string in a file.
#
check_string_in_file()
{
   if  grep "${1}" "${2}" == 0; then
      return 0;
   else
      return 1;
   fi
}

#
# Check for the flag
#
check_for_flag()
{
   if [ -e "${1}" ] ; then
      return 0;
   else
      return 1;
   fi
}

#
# Creates flag indicating the apps cache has been moved.
#
make_flag()
{
   echo "" > /Applications/OSX-RAMDisk.app/"${1}"
}

# ------------------------------------------------------
# Applications, which needs the cache to be moved to RAM
# Add yours at the end.
# -------------------------------------------------------

#
# Google Chrome Cache
#


move_chrome_cache()
{
   if [ -d "/Users/${USER}/Library/Caches/Google/Chrome" ]; then
      if user_response "${MSG_PROMPT_FOUND}" 'Chrome'"${MSG_MOVE_CACHE}" ; then
         close_app "Google Chrome"
         /bin/mkdir -p /tmp/Google
         /bin/mv ~/Library/Caches/Google/Chrome/* /tmp/Google
         /bin/mkdir -pv "${USERRAMDISK}"/Google
         /bin/mv /tmp/Google/* "${USERRAMDISK}"/Google
         /bin/ln -v -s -f "${USERRAMDISK}"/Google ~/Library/Caches/Google/
         /bin/rm -rf /tmp/Google
         # and let's create a flag for next run that we moved the cache.
         echo "";
      fi
   else
      echo "No Google Chrome folder has been found. Skipping."
   fi
}


move_chrome_cache()
{
   if [ -d "/Users/${USER}/Library/Caches/Google/Chrome" ]; then
      if user_response "${MSG_PROMPT_FOUND}" 'Chrome'"${MSG_MOVE_CACHE}" ; then
         close_app "Google Chrome"
         /bin/mkdir -p /tmp/Google
         /bin/mv ~/Library/Caches/Google/Chrome/* /tmp/Google
         /bin/mkdir -pv "${USERRAMDISK}"/Google
         /bin/mv /tmp/Google/* "${USERRAMDISK}"/Google
         /bin/ln -v -s -f "${USERRAMDISK}"/Google ~/Library/Caches/Google/
         /bin/rm -rf /tmp/Google
         # and let's create a flag for next run that we moved the cache.
         echo "";
      fi
   else
      echo "No Google Chrome folder has been found. Skipping."
   fi
}

move_brave_cache()
{
   if [ -d "/Users/${USER}/Library/Caches/BraveSoftware/Brave-Browser" ]; then
      if user_response "${MSG_PROMPT_FOUND}" 'Brave'"${MSG_MOVE_CACHE}" ; then
         close_app "Google Chrome"
         /bin/mkdir -p /tmp/Google
         /bin/mv ~/Library/Caches/BraveSoftware/Brave-Browser/* /tmp/Brave
         /bin/mkdir -pv "${USERRAMDISK}"/Brave
         /bin/mv /tmp/Google/* "${USERRAMDISK}"/Brave
         /bin/ln -v -s -f "${USERRAMDISK}"/Brave ~/Library/Caches/BraveSoftware/
         /bin/rm -rf /tmp/Brave
         # and let's create a flag for next run that we moved the cache.
         echo "";
      fi
   else
      echo "No Brave Browser folder has been found. Skipping."
   fi
}

#
# Chromium Cache
#
move_chromium_cache()
{
   if [ -d "/Users/${USER}/Library/Caches/Chromium" ]; then
      if user_response "${MSG_PROMPT_FOUND}" 'Chromium/Iron'"${MSG_MOVE_CACHE}" ; then
         close_app "SRWare Iron"
         /bin/mkdir -p /tmp/Chromium
         /bin/mv ~/Library/Caches/Chromium/* /tmp/Chromium
         /bin/mkdir -pv "${USERRAMDISK}"/Chromium
         /bin/mv /tmp/Chromium/* "${USERRAMDISK}"/Chromium
         /bin/ln -v -s -f "${USERRAMDISK}"/Chromium ~/Library/Caches/Chromium/
         /bin/rm -rf /tmp/Chromium
         # and let's create a flag for next run that we moved the cache.
         echo "";
      fi
   else
      echo "No Chromium folder has been found. Skipping."
   fi
}

#
# Chrome Canary Cache
#
move_chrome_chanary_cache()
{
   if [ -d "/Users/${USER}/Library/Caches/Google/Chrome Canary" ]; then
      if user_response "${MSG_PROMPT_FOUND}" 'Chrome Canary'"${MSG_MOVE_CACHE}" ; then
         close_app "Chrome Canary"
         /bin/rm -rf ~/Library/Caches/Google/Chrome\ Canary/*
         /bin/mkdir -p "${USERRAMDISK}"/Google/Chrome\ Canary/Default
         /bin/ln -s "${USERRAMDISK}"/Google/Chrome\ Canary/Default ~/Library/Caches/Google/Chrome\ Canary/Default
      fi
   fi
}

#
# Safari Cache
#
move_safari_cache()
{
   if [ -d "~/Library/Caches/com.apple.Safari" ]; then
      if user_response "${MSG_PROMPT_FOUND}" 'Safari'"${MSG_MOVE_CACHE}"; then
         close_app "Safari"
         /bin/rm -rf ~/Library/Caches/com.apple.Safari
         /bin/mkdir -p "${USERRAMDISK}"/Apple/Safari
         /bin/ln -s "${USERRAMDISK}"/Apple/Safari ~/Library/Caches/com.apple.Safari
         echo "Moved Safari cache."
      fi
   fi
}

#
# iTunes Cache
#
move_itunes_cache()
{
   if [ -d "~/Library/Caches/com.apple.iTunes" ]; then
      if user_response "${MSG_PROMPT_FOUND}" 'iTunes'"${MSG_MOVE_CACHE}" ; then
         close_app "iTunes"
         /bin/rm -rf ~/Library/Caches/com.apple.iTunes
         /bin/mkdir -pv "${USERRAMDISK}"/Apple/iTunes
         /bin/ln -v -s "${USERRAMDISK}"/Apple/iTunes ~/Library/Caches/com.apple.iTunes
         echo "Moved iTunes cache."
      fi
   fi
}

#
# Webstorm
#
move_webstorm_cache()
{
   if [ -d "/Users/${USER}/Library/Application\ Support/JetBrains/Toolbox/apps/WebStorm/ch-0/193.6494.34" ]; then
      if user_response "${MSG_PROMPT_FOUND}" 'WebStorm'"${MSG_MOVE_CACHE}" ; then
         close_app "Webstorm Idea"
         # make a backup of config - will need it when uninstalling
         cp -f /Users/"${USER}"/Library/Preferences/WebStorm2019.3/idea.properties /Users/"${USER}"/Library/Preferences/WebStorm2019.3/idea.properties.back
         # Idea will create those dirs
         echo "idea.system.path=${USERRAMDISK}/WebStorm" >> /Users/"${USER}"/Library/Preferences/WebStorm2019.3/idea.properties
         echo "idea.log.path=${USERRAMDISK}/WebStorm/logs" >> /Users/"${USER}"/Library/Preferences/WebStorm2019.3/idea.properties
         echo "Moved WebStorm cache."
      fi
   fi
}

#
# Xcode - ios
#
move_xcode_cache()
{
   if [ -d "/Applications/Xcode.app" ]; then
      if user_response "${MSG_PROMPT_FOUND}" 'Xcode'"${MSG_MOVE_CACHE}" ; then
         echo "moving XCode cache..";
         echo "deleting ~/Library/Developer/Xcode/DerivedData"

         /bin/rm -rvf ~/Library/Developer/Xcode/DerivedData
         /bin/mkdir -pv "${USERRAMDISK}"/Apple/Xcode
         /bin/ln -v -s "${USERRAMDISK}"/Apple/Xcode /Users/"${USER}"/Library/Developer/Xcode/DerivedData
         echo "Moved Xcode cache."
      fi
   fi
}


# -----------------------------------------------------------------------------------
# The entry point
# -----------------------------------------------------------------------------------
main() {
   check_requirements
   # and create our RAM disk
   mk_ram_disk
   # move the caches
   move_chrome_cache
   move_brave_cache
   move_chromium_cache
   move_safari_cache
   move_webstorm_cache
   move_itunes_cache
   move_xcode_cache
   echo "All good - I have done my job. Your apps should fly."
}

main "$@"
# -----------------------------------------------------------------------------------
