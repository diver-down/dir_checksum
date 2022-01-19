#!/bin/bash
#
#
#
# NOTE: this script *syncs* all changes from VID01 to BKP01-EXT
#       (deletions are propagated)

echo " "
echo " "
echo "====================================================="
echo "====================================================="
echo "====================================================="
echo "This script syncs changes from VAULT to VID01-EXT"
echo "            (deletions are propagated)   "
echo "Permissions are not preserved, instead left at dest. "
echo "====================================================="
echo "====================================================="
echo "====================================================="
echo " "
echo " "
echo "====================================================="
echo "           Updating VAULT checksums now              "
echo "====================================================="
echo " "
echo " "

cd /mnt/VAULT/Production-Archive
pwd
echo " "
echo "Cleaning OS metafiles"
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
echo " "
echo " "
cd /mnt/VAULT/New-Jersey-Shipwrecks
pwd
echo " "
echo "Cleaning OS metafiles"
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
echo " "
echo " "
echo " "
echo "====================================================="
echo "           VAULT checksums updated              "
echo "====================================================="
echo " "
echo " "

cd ~

echo " "
echo " "
echo "====================================================="
echo "         Syncing VAULT to VID01-EXT now              "
echo "====================================================="
echo " "
echo " "

rsync -vrltDhi --progress --stats --delete /mnt/VAULT/New-Jersey-Shipwrecks /run/media/user/VID01/New-Jersey-Shipwrecks/
echo "====================================================="
echo "====================================================="
echo "====================================================="
rsync -vrltDhi --progress  --stats --delete /Volumes/VID01/Production-Archive/ /run/media/user/VID01/Production-Archive/

echo " "
echo " "
echo "====================================================="
echo "                  Synchronized             "
echo "====================================================="
echo " "
echo " "
echo "====================================================="
echo " "
echo " "
echo "====================================================="
echo "     Validating VID01-EXT sync checksums now         "
echo "====================================================="
echo " "
echo " "

cd /run/media/user/VID01/Production-Archive
pwd
echo " "
echo "Cleaning OS metafiles"
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
echo "====================================================="
cd /run/media/user/VID01/New-Jersey-Shipwrecks
pwd
echo " "
echo "Cleaning OS metafiles"
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
