#!/bin/bash
##Variable to store # of hours before a new inventory collection is needed
Hours="3"
##Path to local last recon time stamp file
lastReconFile="/Library/Application Support/JAMF/.last_recon_time"
function checkDifference ()
{
##Convert hours into seconds
Secs=$((60*60*Hours))
##Get current time in Unix seconds
timeNow=$( date +%s )
##Get the last recon time stamp from file and store into variable
lastReconTime=$( cat "$lastReconFile" )
##Determine difference in seconds between the last time stamp and current time
timeDiff=$(( timeNow-lastReconTime ))
if [[ "$timeDiff" -ge "$Secs" ]]; then
    echo "Has been at least 3 hours since last recon. Starting inventory collection..."
    sudo jamf recon
    echo "Updating the time stamp file with new current time information…"
    echo "$( date +%s )" > "$lastReconFile"
else
    echo "Has not been at least 3 hours since last recon. Exiting..."
    exit 0
fi
}
##Check to see if the last recon timestamp file is there
if [[ -e "$lastReconFile" ]]; then
    ##Run the function to check the time difference
    checkDifference
else
    echo "Last recon timestamp file was not found. Starting inventory collection..."
    sudo jamf recon
    echo "Creating last recon timestamp file with current time information..."
    echo "$( date +%s )" > "$lastReconFile"
fi
exit 0