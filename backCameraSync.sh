echo Syncing folders

syncFiles=$(find /volume1/surveillance/Back -mtime 0 -type f -printf '%T@\t%p\n' | sort -t $'\t' -g| cut -d $'\t' -f 2-)
for syncFile in $syncFiles
do
        echo -n Transferring $syncFile
    destFile=${syncFile/\/volume1/\/volume1\/CloudSync}
    echo to $destFile
    mkdir -p $(dirname "$destFile")
    cp -uv "${syncFile}" "${destFile}"
done

echo Removing extra files
find /volume1/CloudSync/surveillance/Back -type f -printf '%T@\t%p\n' |
grep mp4 |
sort -t $'\t' -g |
head -n -288 |
cut -d $'\t' -f 2- |
xargs rm -rf {}
