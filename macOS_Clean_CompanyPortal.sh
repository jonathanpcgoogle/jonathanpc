
#!/bin/bash
#Script to remove Intune Registration item 

#Getting the LoggedinUser User ID in currentUser variable
currentUser=$(python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')
echo "Currently $currentUser logged in"


echo "Remove Intune Registration items"
rm -rf '/Users/$currentUser/Library/Application Support/com.microsoft.CompanyPortal'
rm -rf '/Users/$currentUser/Library/Application Support/com.microsoft.CompanyPortal.usercontext.info'
rm -rf '/Users/$currentUser/Library/Saved Application State/com.jamf.management.jamfAAD.savedState'
rm -rf '/Users/$currentUser/Library/Saved Application State/com.microsoft.CompanyPortal.savedState'
rm -rf '/Users/$currentUser/Library/Preferences/com.jamf.management.jamfAAD.plist'
rm -rf '/Users/$currentUser/Library/Preferences/com.microsoft.CompanyPortal.plist'
rm -rf '/Users/$currentUser/Library/Cookies/com.jamf.management.jamfAAD.binarycookies' 
rm -rf '/Users/$currentUser/Library/Cookes/com.jamf.management.jamfAAD.binarycookies_tmp_41392_0.dat'
rm -rf '/Users/$currentUser/Library/Cookes/com.microsoft.CompanyPortal.binarycookies'


echo "Remove keychain items"

security delete-generic-password -l 'com.jamf.management.jamfAAD'
security delete-generic-password -l 'com.microsoft.CompanyPortal'
security delete-generic-password -l 'com.microsoft.CompanyPortal.HockeySDK'
security delete-generic-password -l 'com.microsoft.adalcache'
security delete-generic-password -l 'enterpriseregistration.windows.net'
security delete-generic-password -a 'com.microsoft.workplacejoin.deviceOSVersion'
security delete-generic-password -a 'com.microsoft.workplacejoin.thumbprint'
security delete-generic-password -a 'com.microsoft.workplacejoin.registeredUserPrincipalName'
security delete-generic-password -l 'https://adfs.ericsson.com/adfs/ls'
security delete-generic-password -l 'https://adfs.ericsson.com/adfs/ls/'
security delete-generic-password -l 'https://device.login.microsoftonline.com'
security delete-generic-password -l 'https://device.login.microsoftonline.com/' 
security delete-generic-password -l 'https://enterpriseregistration.windows.net' 
security delete-generic-password -l 'https://enterpriseregistration.windows.net/' 


removecert=$(security find-certificate -a -Z | grep -B 9 "MS-ORGANIZATION-ACCESS" | grep "SHA-1" | awk '{print $3}')
echo $removecert
security delete-identity -Z $removecert

exit 0