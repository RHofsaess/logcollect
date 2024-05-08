#!/bin/bash
# This script is used to remove unnecessary logs, e.g. from other sites that are not relevant
# It just simply zgreps through all the files and checks, if the chosen identifier is available in the .tar.gz file
# But in principle, all sort of unique identifiers can be used
# For HoreKa, e.g. "localdomain" is sufficient to identify the site with the Hostname in the _condor_stdout
# Usage: ./cleanup.sh <directory> <selection>

directory=$1
selection=$2

# Find and loop through each tar.gz file in the source directory and its subdirectories
find "${directory}" -type f -name "*.tar.gz" | while read tar_file; do
    #echo "checking ${tar_file}..."
    # Use zgrep to search for the string in "_condor_stdout" within the tar.gz file
    if ! zgrep -q "${selection}" "$tar_file"; then
        echo "removing:${tar_file}"
        rm ${tar_file}
    else
        echo "Keep: ${tar_file}"
    fi
done

echo "#############################################################"
echo "Empty directories are now removed!!!"
echo "To remove empty directories, we use: $ find '<parent-dir>' -type d -empty -delete"
echo "+++++Only press Enter, when >>'${directory}'<< is the correct directory!!+++++" 
echo "Or exit with Crtl+C"
echo "#############################################################"
read -p ""  # Waits for user to press Enter

# remove empty dirs
find "${directory}" -type d -empty -delete

echo "Done."
