#!/bin/bash                                                                                         
# This script is used to get all (including the successful!!) logs for debugging from the T1 site directly
# NOTE: This only works as long as the LogCollect jobs didn't remove them already!
# Usage: ./collect_logs.sh <year> <month> <day> <campaign-identifier> NOTE: month and day without prefixed 0 ("1", not "01")
# The identifiers can be found with xrdfs ls, in HappyFace, or in monit-opensearch. DataProcessing e.g. is "pdmvserv_".

year=$1
month=$2
day=$3
CAMPAIGN=$4
REDIRECTOR="root://cmsxrootd-1.gridka.de:1094/"
SOURCE_DIR="/store/unmerged/logs/prod/${year}/${month}/${day}"
DESTINATION_DIR="./${year}${month}${day}"

# Get dirs:
DIRS=$(xrdfs root://cmsxrootd-1.gridka.de:1094/ ls ${SOURCE_DIR} | grep "${CAMPAIGN}")
echo "Get directories: ${DIRS}"
echo ""
echo "Press Enter to download directories containing: ${CAMPAIGN}."
read -p ""  # Waits for user to press Enter

# Check if the destination directory exists, create it if it doesn't
if [ ! -d "$DESTINATION_DIR" ]; then
    mkdir -p "$DESTINATION_DIR"
fi

# Copy the directories via xrdcp
echo "Begin copying"
for dir in $DIRS; do
    echo $dir
    mkdir -p ./${year}${month}${day}/$dir
    xrdcp -r root://cmsxrootd-1.gridka.de:1094/$dir ./${year}${month}${day}/$dir
done

echo "Copied."
