#!/bin/bash
#
#
#
# NOTE: this script *syncs* all changes from VID01 to BKP01-EXT
#       (deletions are propagated)


# REMINDER: Be sure to include the trailing slash in paths (for contents):
source1="/Volumes/VID01/New-Jersey-Shipwrecks/"
dest1="/Volumes/xxxxxxxxx/New-Jersey-Shipwrecks/"

source2="/Volumes/VID01/Production-Archive/"
dest2="/Volumes/xxxxxxxxxxx/Production-Archive/"

pause(){
 while read -r -t 0.001; do :; done # dump the buffer
 read -n1 -rsp $'\n\n   Press any key to continue, or Ctrl+C to exit...\n'
}

echo " "
echo " "
echo "====================================================="
echo "====================================================="
echo "====================================================="
echo "This script syncs changes from"
echo "$source1"
echo "$source2"
echo "                           to "
echo "$dest1"
echo "$dest2"
echo "            (deletions are also propagated)   "
echo "Permissions are not preserved, instead match dest... "
echo "====================================================="
echo "====================================================="
echo "====================================================="
echo " "
echo " "
echo "====================================================="
echo "           Updating source checksums now...              "
echo "====================================================="
echo " "
echo " "

cd "$source1"
echo "Starting $source1"

if [ ! -x "checksum-tracker.sh" ]; 
then
echo "  > ABORTING <      ERROR: checksum-tracker.sh (or chmod +x) does NOT exist in directory: " && pwd && exit 2
else
echo "checksum-tracker.sh found with good permissions, continuing..."
fi

echo " "
echo "Cleaning OS metafiles:"
pwd
echo " "
find . -name '.DS_Store' -print
find . -name '.DS_Store' -delete
find . -name '._*' -print
find . -name '._*' -delete
find . -name 'Thumbs.db' -print
find . -name 'Thumbs.db' -delete
find . -name 'Desktop.ini' -print
find . -name 'Desktop.ini' -delete
find . -name 'desktop.ini' -print
find . -name 'desktop.ini' -delete
echo " "
echo "Checksumming:"
pwd
./checksum-tracker.sh
echo " "
echo " "




cd "$source2"
echo "Starting $source2"

if [ ! -x "checksum-tracker.sh" ]; 
then
echo "  > ABORTING <      ERROR: checksum-tracker.sh (or chmod +x) does NOT exist in directory: " && pwd && exit 2
else
echo "checksum-tracker.sh found with good permissions, continuing..."
fi


echo " "
echo "Cleaning OS metafiles:"
pwd
echo " "
find . -name '.DS_Store' -print
find . -name '.DS_Store' -delete
find . -name '._*' -print
find . -name '._*' -delete
find . -name 'Thumbs.db' -print
find . -name 'Thumbs.db' -delete
find . -name 'Desktop.ini' -print
find . -name 'Desktop.ini' -delete
find . -name 'desktop.ini' -print
find . -name 'desktop.ini' -delete
echo " "
echo "Checksumming:"
pwd
./checksum-tracker.sh
echo " "
echo " "
echo " "
echo "====================================================="
echo "           Source checksums updated                  "
echo "====================================================="
echo " "
echo " "

cd ~

pause

echo " "
echo " "
echo "====================================================="
echo "         Syncing sources to destinations now...      "
echo "====================================================="
echo " "
echo " "
echo "RSYNC:  $source1   to   $dest1"
rsync -vrltDhiq --progress --stats --delete "$source1" "$dest1"
echo "====================================================="

pause

echo "====================================================="
echo "RSYNC:  $source2   to   $dest2"
rsync -vrltDhiq --progress  --stats --delete "$source2" "$dest2"

echo " "
echo " "
echo "====================================================="
echo "                  Synchronized             "
echo "====================================================="
echo " "
echo " "
pause
echo " "
echo " "
echo "====================================================="
echo "     Validating destination checksums now...         "
echo "====================================================="
echo " "
echo " "

cd "$dest1"
echo "Starting $dest1"

if [ ! -x "checksum-tracker.sh" ]; 
then
echo "  > ABORTING <      ERROR: checksum-tracker.sh (or chmod +x) does NOT exist in directory: " && pwd && exit 2
else
echo "checksum-tracker.sh found with good permissions, continuing..."
fi

echo " "
echo "Cleaning OS metafiles:"
pwd
echo " "
find . -name '.DS_Store' -print
find . -name '.DS_Store' -delete
find . -name '._*' -print
find . -name '._*' -delete
find . -name 'Thumbs.db' -print
find . -name 'Thumbs.db' -delete
find . -name 'Desktop.ini' -print
find . -name 'Desktop.ini' -delete
find . -name 'desktop.ini' -print
find . -name 'desktop.ini' -delete
echo " "
echo "Checksumming:"
pwd
./checksum-tracker.sh
echo "====================================================="


cd "$dest2"
echo "Starting $dest2"

if [ ! -x "checksum-tracker.sh" ]; 
then
echo "  > ABORTING <      ERROR: checksum-tracker.sh (or chmod +x) does NOT exist in directory: " && pwd && exit 2
else
echo "checksum-tracker.sh found with good permissions, continuing..."
fi

echo " "
echo "Cleaning OS metafiles:"
pwd
echo " "
find . -name '.DS_Store' -print
find . -name '.DS_Store' -delete
find . -name '._*' -print
find . -name '._*' -delete
find . -name 'Thumbs.db' -print
find . -name 'Thumbs.db' -delete
find . -name 'Desktop.ini' -print
find . -name 'Desktop.ini' -delete
find . -name 'desktop.ini' -print
find . -name 'desktop.ini' -delete
echo " "
echo "Checksumming..."
pwd
./checksum-tracker.sh
cd ~
echo " "
echo " "
echo "====================================================="
echo "  Checksum validation complete - See results above   "
echo "====================================================="
echo " "
echo " "
