#!/bin/bash

echo ""
echo "========================="
echo ""
echo "CHECKSUM UPDATER :)"
echo ""
echo "Includes:"
echo " ~/Education/"
echo " ~/Horse/"
echo " ~/Production-Active/"
echo " ~/Personal/"
echo " ~/SSSAS/"
echo " ~/ScubaTech/"
echo ""
echo "TODO: Movies, Music, Pictures..."
echo "(need to free from Apple first)"
echo ""
echo "========================="
echo ""

cd ~/Education

pwd

./checksum-tracker.sh

echo ""
echo "========================="
echo ""

cd ~/Horse

pwd

./checksum-tracker.sh

echo ""
echo "========================="
echo ""

cd ~/Production-Active

pwd

./checksum-tracker.sh

echo ""
echo "========================="
echo ""

cd ~/Personal

pwd

./checksum-tracker.sh

echo ""
echo "========================="
echo ""

cd ~/SSSAS

pwd

./checksum-tracker.sh

echo ""
echo "========================="
echo ""

cd ~/ScubaTech

pwd

./checksum-tracker.sh

echo ""    
echo "========================="
echo ""


cd ~

pwd
echo ""
echo "Done!"
echo ""
exit

