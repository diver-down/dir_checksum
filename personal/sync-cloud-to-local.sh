#!/bin/bash
clear
echo "----------"
echo "----------"
echo "----------" 
echo "Syncing from SdT OneDrive to local:"
echo "(any local differences will be overwritten)"
rclone sync --progress OD: ~/SYNC-SdT-OneDrive/
echo "----------"
echo "Checking from SdT OneDrive to local:"
rclone check --one-way --progress OD: ~/SYNC-SdT-OneDrive/
echo "----------"
echo "----------"
echo "----------"
echo "Syncing from CWD Dropbox to local:"                                      
echo "(any local differences will be overwritten)"
rclone sync --progress DB: ~/SYNC-CWD-Dropbox/
echo "----------"
echo "Checking from SdT OneDrive to local:"
rclone check --one-way --progress DB: ~/SYNC-CWD-Dropbox/
echo "----------"
echo "----------"
echo "----------"
