#!/bin/sh

/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -title "MacOS Updates" -description "Mandiant ETS is about to enforce Security Updates on your Mac. A reboot may be required if there are pending updates. This will be activated once you click BEGIN. Please save any open work before pressing BEGIN. 

Note: While you can drag this pop-up off-screen note that deferring your updates adds security risk and is reported on for compliance" -icon /System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/ToolbarInfo.icns -button1 "BEGIN" -defaultButton 1


sudo jamf removeSWUSettings 

defaults write /Library/Preferences/com.apple.commerce AutoUpdate -bool TRUE

defaults write /Library/Preferences/com.apple.commerce AutoUpdateRestartRequired -bool TRUE

defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -bool TRUE

killall cfprefsd

ifconfig | grep inet

softwareupdate -i -a -R --force --verbose
