#!/bin/bash
#
#
# Destination - Filesystems That Use Permissions
# E.G.; brtfs, ext4, zfs
#
# NOTE: this script *syncs* all changes from VID01 to BKP04
#       (deletions are propagated)

echo " "
echo " "
echo "====================================================="
echo "====================================================="
echo "====================================================="
echo "This script SYNCS all changes from VID01 to BKP04"
echo "      and ~/Production-Active to BKP04 "
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
echo " "
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
echo " "
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
echo "           VID01 checksums updated                   "
echo "====================================================="
echo " "
echo " "

cd ~

echo " "
echo " "
echo "====================================================="
echo "         Syncing VID01 to BKP04 now                  "
echo "====================================================="
echo " "
echo " "

rsync -vrltDhi --checksum --progress --stats --delete /Volumes/VID01/New-Jersey-Shipwrecks/ /Volumes/BKP04/New-Jersey-Shipwrecks/
echo "====================================================="
echo "====================================================="
echo "====================================================="
rsync -vrltDhi --checksum --progress --stats --delete /Volumes/VID01/Production-Archive/ /Volumes/BKP04/Production-Archive/

echo " "
echo " "
echo "====================================================="
echo "         VID01 to BKP04 Synchronized                 "
echo "====================================================="
echo " "
echo " "


echo " "
echo " "
echo "====================================================="
echo "         Syncing ~/Production-Active to BKP04 now    "
echo "====================================================="
echo " "
echo " "

rsync -vrltDhi --checksum --progress --stats --delete ~/Production-Active/ /Volumes/BKP04/Production-Active/

cd /Volumes/BKP04/Production-Active
echo " "
pwd
echo " "
echo "Cleaning macOS metadata"
echo " "
find . -name '.DS_Store' -print
find . -name '.DS_Store' -delete
find . -name '._*' -print
find . -name '._*' -delete
echo " "
echo "Verifying Production-Active on BKP04 checksums"
echo " "
pwd
./checksum-tracker.sh

echo " "
echo " "
echo "====================================================="
echo "         ~/Production-Active to BKP04 Synchronized   "
echo "====================================================="
echo " "
echo " "








echo " "
echo " "
echo "====================================================="
echo "   Validating BKP04 sync from VID01 checksums now    "
echo "====================================================="
echo " "
echo " "

cd /Volumes/BKP04/Production-Archive
echo " "
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

cd /Volumes/BKP04/New-Jersey-Shipwrecks
echo " "
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

