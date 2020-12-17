# Checksum Tracker
Ever had a file silently corrupt and propagate to backup? It's a horrible feeling, no matter the scope... and even worse when the data genuinely mattered. This phenomenon is known as *bit-rot* and affects everything from HDDs to SSDs, and even data in non-ECC RAM. Checksumming prevents it — well, more specifically, checksumming detects nearly all bit-rot and can either fix the issue or warn the user so they can manually restore.

**Checksum Tracker** (`checksum-tracker.sh`) is a directory verification bash shell script used to compute a recursive directory (folder) checksum, and output change information each time it is ran. In essence; it does the thing (Zhu Li)

Instead of running automatically and at a block-level (like BTRFS, ZFS, etc), this utility is ran manually at the file-level. This allows protection of assets in environments that must be portable and compatible with OSs that don't support checksumming filesystems, as well as gives a way to quickly audit shared volumes for visibility on team member changes and updates. It's also a great way to verify external drives and backup stores before pulling/copying/restoring files.

---

## Authors
- This forked codebase version and modifications are by C.D. @ https://github.com/scuba-tech/checksum-tracker
- First derivation credit and idea goes to Mark Kuo (starryalley@gmail.com), found at https://github.com/starryalley/dir_checksum

---

## INSTRUCTIONS
This script is designed to be simple and portable.

Simply place a copy of checksum-tracker.sh in the top/root level of any project folder or external drive.

Then, allow execution with `chmod +x checksum-tracker.sh`

To use, simply navigate your CLI/Terminal to the project folder, and then execute locally with `./checksum-tracker.sh`

---

## Details
On the first run, this script will compute an md5 checksum of all files in that directory recursively and save the results to a checksum file titled .dir_checksum

Subsequent executions on that directory will compare the last checksum with current one, update the records, and then report missing, added, and modified files. Additionally, a copy of the previous checksum data is saved to .dir_checksum.old for backup purposes.

One of the main modifications of this script, compared to the original source, is that all records are stored as relative paths. This means that this script should be located at the top/root directory of any project or drive, and that it is now completely portable between users and systems.

---

## Dependencies
`md5sum/md5; diff; comm; xargs; find; sort; grep; sed; rm; mv; wc; cut; uniq`

## Optional
`pv`

(macOS users can install with Homebrew: `brew install pv`)

---

## Tested on:
- macOS Catalina 10.15.7
