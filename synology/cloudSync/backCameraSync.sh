#!/bin/bash
# Files recorded by Synology Surveillance app arrive in /volume1/surveillance/Back
# Files are copied to CloudSync directory that is syncronized with google Drive. 
# We only want the last 2 days available on google drive due to space constraints
# 
echo Syncing folders

# Grab all files modified today
syncFiles=$(find /volume1/surveillance/Back -mtime 0 -type f -printf '%T@\t%p\n' | sort -t $'\t' -g| cut -d $'\t' -f 2-)

# Transfer each file to cloudsync if does not exist, create directory structure
for syncFile in $syncFiles
do
    echo -n Transferring $syncFile
    destFile=${syncFile/\/volume1/\/volume1\/CloudSync}
    echo to $destFile
    mkdir -p $(dirname "$destFile")
    cp -uv "${syncFile}" "${destFile}"
done

echo Removing extra files
# one file every 10 min, and we want to keep 2 days = 288 files
find /volume1/CloudSync/surveillance/Back -type f -printf '%T@\t%p\n' |
grep mp4 |
sort -t $'\t' -g |
head -n -288 |
cut -d $'\t' -f 2- |
xargs rm -rf {}
