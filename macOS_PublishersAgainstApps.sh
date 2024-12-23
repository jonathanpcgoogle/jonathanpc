#!/bin/bash
####################################################################################################
# Create a PublishersAgainstApps Text file listed all the applications(.app) in MAC and Publisher Detail against all the applications
####################################################################################################
# OS X Version
osx_vers_Major=$(/usr/bin/sw_vers -productVersion | /usr/bin/cut -d. -f 1)
osx_vers_Minor=$(/usr/bin/sw_vers -productVersion | /usr/bin/cut -d. -f 2)
allApps="/private/var/EnterpriseManagement/AllApps.txt"
notAllowedApps="/private/var/EnterpriseManagement/PublishersAgainstApps.txt"
####################################################################################################
if [[ -f $notAllowedApps ]]; then
    rm -f $notAllowedApps
fi
if [[ "$osx_vers_Major" -eq 10 ]] && [[ "$osx_vers_Minor" -lt 15 ]]; then
    echo "The mac is running on $osx_vers_Major.$osx_vers_Minor"
    nice -n 10 find / -iname *.app -print > $allApps
else
    echo "The mac is running on $osx_vers_Major.$osx_vers_Minor"
    nice -n 10 find /System/Volumes/Data/Volumes/*/Applications -iname *.app -print > $allApps
    nice -n 10 find /System/Volumes/Data/Volumes/*/Library -iname *.app -print >> $allApps
    nice -n 10 find /System/Volumes/Data/Volumes/*/Users -iname *.app -print >> $allApps
fi
while IFS= read -r var
do
    if [[ "$(codesign -dv --verbose=4 "$var" 2>&1 | grep "Authority" | head -1)" != "Authority=Software Signing" ]]; then
        echo "$var" >> $notAllowedApps
        codesign -dv --verbose=4 "$var" 2>&1 | grep "Authority" | head -1 >> $notAllowedApps
    fi
done < "$allApps"
exit 0
