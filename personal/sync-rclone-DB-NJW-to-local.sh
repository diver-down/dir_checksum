# REMINDER: include the trailing slashes
remote="DB:NJ Shipwrecks/"
local="/Volumes/VID01/New-Jersey-Shipwrecks/"

echo "big warning about how this will pulldown and overwrite all"

# if checksums, move all checksums out to temp
# again for checksums
# again for checksums.old


# rclone sync (deletions propagated) Dropbox remote to local
rclone sync --progress "$remote" "$local" --tpslimit 8 

# move checksums back from temp

# re-run checksum-tracker to update hashes
# output will show what pulldown has changed on local
