-----------------------------------------------------------------------------------------------------
#!/bin/bash 
# pop-up dialog before a policy has run 
# uses jamfHelper 
# Determine OS version 
osvers=$(sw_vers -productVersion | awk -F. '{print $1$2}') 
currentUser=$(/usr/bin/stat -f%Su /dev/console) 
loggedinUserId=$(id -u "$currentUser") 
echo "$osvers" 
echo "$currentUser" 
echoo "$loggedinUserId" 
------------------------------------------------------------------------------------------------------ 
dialog="If you have $4 installed and opened, it will be force quit when you click 'OK'" 
description=`echo "$dialog"` 
button1="OK" 
#button2="Cancel" 
jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper" 
curl https://ics.services.jamfcloud.com/icon/hash_8b6c3605dc17c7a62de8bacb9e8a0cb58230733785b08d62887b85e410b8e875 > /private/var/tmp/Company_icon.png 
icon="/private/var/tmp/Company_icon.png" 
userChoice=$("$jamfHelper" -windowType utility -title "$4 Install/Update" -description "$description" -button1 "$button1" -icon "$icon")   

  if [ "$userChoice" == "0" ]; then    

    sudo pkill -f $5 

   fi 

  #if [ "$userChoice" == "2" ]; then    

    #sudo killall jamfHelper 
    #exit 1 

  #fi 

exit 0 
