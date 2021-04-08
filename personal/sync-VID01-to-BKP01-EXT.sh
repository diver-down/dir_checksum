#!/bin/bash
#
#
# Destination - Filesystems That Use Permissions
# E.G.; brtfs, ext4, zfs
#
# NOTE: this script *syncs* all changes from VID01 to BKP01-EXT
#       (deletions are propagated)

echo " "
echo " "
echo "====================================================="
echo "====================================================="
echo "====================================================="
echo "This script SYNCS all changes from VID01 to BKP01-EXT"
echo "            (deletions are propagated)"
echo "====================================================="
echo "====================================================="
echo "====================================================="
echo " "
echo " "
echo "====================================================="
echo "           Updating VID01 checksums now              "
echo "====================================================="
echo " "
echo " "

cd /Volumes/VID01/Production-Archive
pwd
echo " "
echo "Cleaning macOS metadata"
echo " "
find . -name '.DS_Store' -print
find . -name '.DS_Store' -delete
find . -name '._*' -print
find . -name '._*' -delete
echo " "
pwd
./checksum-tracker.sh

cd /Volumes/VID01/New-Jersey-Shipwrecks
pwd
echo " "
echo "Cleaning macOS metadata"
echo " "
find . -name '.DS_Store' -print
find . -name '.DS_Store' -delete
find . -name '._*' -print
find . -name '._*' -delete
echo " "
pwd
./checksum-tracker.sh

echo " "
echo " "
echo "====================================================="
echo "           VID01 checksums updated              "
echo "====================================================="
echo " "
echo " "

cd ~

echo " "
echo " "
echo "====================================================="
echo "         Syncing VID01 to BKP01-EXT now              "
echo "====================================================="
echo " "
echo " "

rsync -avhi --checksum --progress --stats --delete /Volumes/VID01/New-Jersey-Shipwrecks/ /Volumes/BKP01-EXT/New-Jersey-Shipwrecks/
echo "====================================================="
echo "====================================================="
echo "====================================================="
rsync -avhi --checksum --progress  --stats --delete /Volumes/VID01/Production-Archive/ /Volumes/BKP01-EXT/Production-Archive/

echo " "
echo " "
echo "====================================================="
echo "         VID01 to BKP01-EXT Synchronized             "
echo "====================================================="
echo " "
echo " "

echo " "
echo " "
echo "====================================================="
echo "     Validating BKP01-EXT sync checksums now         "
echo "====================================================="
echo " "
echo " "

cd /Volumes/BKP01-EXT/Production-Archive
pwd
echo " "
echo "Cleaning macOS metadata"
echo " "
find . -name '.DS_Store' -print
find . -name '.DS_Store' -delete
find . -name '._*' -print
find . -name '._*' -delete
echo " "
pwd
./checksum-tracker.sh

cd /Volumes/BKP01-EXT/New-Jersey-Shipwrecks
pwd
echo " "
echo "Cleaning macOS metadata"
echo " "
find . -name '.DS_Store' -print
find . -name '.DS_Store' -delete
find . -name '._*' -print
find . -name '._*' -delete
echo " "
pwd
./checksum-tracker.sh

echo " "
echo " "
echo "====================================================="
echo "  Checksum validation complete - See results above   "
echo "====================================================="
echo " "
echo " "

