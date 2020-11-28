#!/bin/bash
#
# checksum-tracker is a directory verification script
#
# AUTHORS:
# This forked version and modifications are by diver-down.
#
# Original credit goes to Mark Kuo (starryalley@gmail.com),
# found at https://github.com/starryalley/dir_checksum
#
# =======================================
#
# INSTRUCTIONS:
# This script is designed to be simple and portable.
#
# Simply place a copy of checksum-tracker.sh in the
# top/root level of any project folder or external drive.
#
# Then, allow execution with chmod +X checksum-tracker.sh
#
# To use, simply navigate your CLI/Terminal to the project
# folder, and then execute locally with ./checksum-tracker.sh
#
# On the first run, this script will compute an md5 checksum
# of all files in that directory recursively and save the
# results to a checksum file titled .dir_checksum
#
# Subsequent executions on that directory will compare
# last checksum with current one, update the records,
# and then report missing, added, and modified files.
# Additionally, a copy of the previous checksum data is
# saved to .dir_checksum.old for backup purposes.
#
# =======================================
#
# PORTABILITY:
# One of the main modifications of this script, compared
# to the original source, is that all records are stored
# as relative paths. This means that this script should
# be located at the top/root directory of any project
# or drive, and that it is now completely portable between
# users and systems.
#
# =======================================
#
# Dependencies:
#  md5sum/md5, diff, comm, xargs, find, sort
#  grep, sed, rm, mv, wc, cut, uniq
#
# Optional:
#  pv
#  (macOS users can install with Homebrew: "brew install pv")
#
# =======================================
#
# Verification:
#  Tested on macOS Catalina 10.15.7
#


# GLOBAL CONFIG
# ==============

# checksum filename (old checksum will have same filename with .old suffix)
CHECKSUM_NAME=".checksums"

# number of parallel process
PARALLEL_COUNT=2

# determine OS
PLATFORM=`uname -s` #'Darwin' for mac, 'Linux' for linux

# md5 program
MD5SUM="md5sum"

# sort program
SORT="sort --ignore-case --dictionary-order"

CUT_FIELD=3

MODCOMM="comm"

# platform specific
if [[ $PLATFORM == 'Linux' ]]; then
    PARALLEL_COUNT=`grep -c ^processor /proc/cpuinfo`
    MD5SUM="md5sum"
    SORT="sort --ignore-case --dictionary-order --parallel=$PARALLEL_COUNT"
    MODCOMM="comm --nocheck-order"
elif [[ $PLATFORM == 'Darwin' ]]; then
    PARALLEL_COUNT=`sysctl hw.ncpu | cut -d: -f2`
    MD5SUM="md5 -r"
    LC_COLLATE="cs_CZ.ISO8859-2"
    echo "macOS Local for Sort set to: "$LC_COLLATE
    SORT="sort --ignore-case --dictionary-order"
    CUT_FIELD=2
fi


# === create checksum ===
# $1 target dir
# $2 target checksum filename
function create_checksum()
{
    local path=$1
    local checksum=$2

    echo "Count files..."
    local count=`find -L "$path" ! -name $CHECKSUM_NAME ! -name $CHECKSUM_NAME.old ! -name .stignore \
    ! -name .DS_Store ! -path "*/.stfolder/*" ! -path "*/.stversions/*" -type f | wc -l`
    echo "$count files found"

    # check pv existence
    local PV_CMD="pv -cN MD5SUM --line-mode -s $count"
    if ! type pv > /dev/null 2>&1; then
        echo "'pv' not installed. Progress bar disabled"
        local PV_CMD="cat" #bypassing
    fi

    echo "Computing checksum..."
    # the long pipeline of 'find | xargs md5sum | pv | sort'
    find -L "$path" ! -name $CHECKSUM_NAME ! -name $CHECKSUM_NAME.old ! -name .DS_Store ! -name .stignore \
         ! -path "*/.stfolder/*" ! -path "*/.stversions/*" -type f -print0 |   #find every file under $path (follow symbolic links)
        xargs -0 -n 1 -P $PARALLEL_COUNT $MD5SUM |  #create md5sum in parallel
        $PV_CMD |                                   #showing nice progress bar using pv
        $SORT -k 2 |                                #should sort or diff will fail badly
        sed '' > "$checksum"                        #save to checksume file only
        #tee "$checksum"                            #save to checksume file and output to screen

    if [ $? -eq 0 ]; then

        if [[ $PLATFORM == 'Darwin' ]]; then
          sed -i '' -e 's/ /  /' $checksum #editing in-place first space to two spaces, " '' -e " for macOS strangeness
          echo "INFO: Checksum tracker standardized for macOS-Linux intercompability."
        fi

        echo "Done. Checksum file written to $checksum"
    else
        echo "Checksum creation failed. Exiting.."
        exit 1
    fi
    echo
}


# === compare checksum ===
# $1 target dir
# $2 old checksum file
# $3 new checksum file
function compare_checksum()
{
    # diff filename
    local DIFF_NAME="${CHECKSUM_NAME}.diff"

    local path=$1
    local old=$2
    local new=$3

    #echo "comparing $old and $new..."
    diff --suppress-common-lines --unified=0 "$old" "$new" |  #diff
        sed '/^@/d;/^---/d;/^+++/d' > "$path/$DIFF_NAME"      #remove other info

    if [ $? -ne 0 ]; then
        echo "Error running diff. Exiting.."
        exit 1
    fi

    # example output here:
    #   -0dea76f1d4581b591409bffe8fe6f722  ../tmp/test_enum/main.c
    #   +330a71bf82c38415860d19490cec2648  ../tmp/test_enum/main.c
    #   -d41d8cd98f00b204e9800998ecf8427e  ../tmp/test_enum/test1
    #   +d41d8cd98f00b204e9800998ecf8427e  ../tmp/test_enum/test3
    # example result:
    #   modified: main.c
    #   missed: test1
    #   added: test3

    # grep - and + respectively into 2 sets (miss and new)
    sed -n '/^-/p' "$path/$DIFF_NAME" | cut -d' ' -f$CUT_FIELD- | $SORT > "$path/$DIFF_NAME.miss"
    sed -n '/^+/p' "$path/$DIFF_NAME" | cut -d' ' -f$CUT_FIELD- | $SORT > "$path/$DIFF_NAME.new"
    sed -n '/^-/p' "$path/$DIFF_NAME" | $SORT -k 2 | cut -c 2- > "$path/$DIFF_NAME.mod1"
    sed -n '/^+/p' "$path/$DIFF_NAME" | $SORT -k 2 | cut -c 2- > "$path/$DIFF_NAME.mod2"

    echo "=== Report ==="
    echo "Modified (with new MD5):"    # the intersection
    awk -F'  ' 'NR==FNR{++a[$2];next} $2 in a' "$path/$DIFF_NAME.mod1" "$path/$DIFF_NAME.mod2" | $SORT -k 2 > "$path/$DIFF_NAME.first.dat"
    awk -F'  ' 'NR==FNR{++a[$2];next} $2 in a' "$path/$DIFF_NAME.mod2" "$path/$DIFF_NAME.mod1" | $SORT -k 2 > "$path/$DIFF_NAME.second.dat"
    $MODCOMM -13 "$path/$DIFF_NAME.second.dat" "$path/$DIFF_NAME.first.dat" | sed '/^$/d'
    echo "--------------"
    echo "Missing:"      #in miss but not in new
    comm -2 "$path/$DIFF_NAME.miss" "$path/$DIFF_NAME.new" | cut -f 1 | sed '/^$/d'
    echo "--------------"
    echo "Added:"       #in new but not in miss
    comm -2 "$path/$DIFF_NAME.new" "$path/$DIFF_NAME.miss" | cut -f 1 | sed '/^$/d'
    echo "--------------"

    # clean up tmp files
    rm "$path/$DIFF_NAME"*
}


# === usage ===
function usage()
{
    local E_BADARGS=65
    echo "Usage: $0 [directory]"
    echo "  directory: the directory to check (default: current directory)"
    exit $E_BADARGS
}


# === main ===

# check arguments
if [ $# -gt 1 ]; then
    echo "Wrong arguments"
    usage
fi

# default: current working directory
dir=${1:-'.'}
if [ ! -e "$dir" ]; then
    echo "$1 doesn't exist or is not a directory. Exiting.."
    exit 1
fi

echo "Platform: $PLATFORM"
echo "Target directory: $dir"
echo "Parallel process: $PARALLEL_COUNT"

# check if checksum already exist
checksum_path="$dir/$CHECKSUM_NAME"
if [ -e "$checksum_path" ]; then
    echo "Old checksum exists. Renamed: $checksum_path.old"
    mv "$checksum_path" "$checksum_path.old"
fi

# create_checksum
create_checksum "$dir" "$checksum_path"

# see if we need to compare
if [ -e "$checksum_path.old" ]; then
    compare_checksum "$dir" "$checksum_path.old" "$checksum_path"
    # keep old copy for reference?
    #rm $checksum_path.old
fi

exit
