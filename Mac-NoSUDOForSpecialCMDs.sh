###########################################
###NO SUDO REQUIRED FOR SPECIAL COMMANDS###
##ITS A DRAFT, REVIEW BEFOR YOU IMPLEMENT##
###########################################
#!/bin/bash 

##NO SUDO FOR NANO, CHOWN AND CHMOD## 
osascript -e 'display alert "Message!" message "You have only 1 Minutes time to Perform. \n \n \t \t Press 'OK' to continue."' 
echo 'ALL ALL=NOPASSWD: /usr/bin/nano,/usr/bin/chmod,/usr/sbin/chown' >> /etc/sudoers 
#currentuser=ls -l /dev/console | cut -d " " -f 4 
sudo touch /Users/accessremove.sh 
sudo echo "sudo sed -i '' -e '\$d' /etc/sudoers" >> /Users/accessremove.sh 
sudo chmod 777 /Users/accessremove.sh 

##LAUNCH DAEMON NO SUDO FOR SPECIAL COMMANDS## 
/bin/cat <<EOF > /Library/LaunchDaemons/com.jamfsoftware.task.nosudocommand.plist 
<?xml version="1.0" encoding="UTF-8"?> 
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd"> 
<plist version="1.0"> 
<dict> 
        <key>Label</key> 
        <string>com.jamfsoftware.task.nosudocommand.plist</string> 
        <key>LaunchOnlyOnce</key> 
<true/> 
        <key>ProgramArguments</key> 
        <array> 
           <string>sudo</string> 
               <string>sh</string> 
               <string>/Users/accessremove.sh</string>                
        </array> 
        <key>StartInterval</key> 
        <integer>60</integer> 
        <key>UserName</key> 
        <string>root</string> 
</dict> 
</plist> 

EOF 

/bin/cat <<EOF > /Library/LaunchDaemons/com.jamfsoftware.task.accessremove.plist 

<?xml version="1.0" encoding="UTF-8"?> 
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd"> 
<plist version="1.0"> 
<dict> 
        <key>Label</key> 
        <string>com.jamfsoftware.task.accessremove.plist</string> 
        <key>LaunchOnlyOnce</key> 
<true/> 
        <key>ProgramArguments</key> 
        <array> 
           <string>sudo</string> 
   <string>rm</string> 
               <string>-rf</string> 
               <string>/Users/accessremove.sh</string>               
        </array> 
        <key>StartInterval</key> 
        <integer>70</integer> 
        <key>UserName</key> 
        <string>root</string> 
</dict> 
</plist> 

EOF 

##CHANGE PERMISSION AND OWNER OF DAEMON## 
/bin/chmod 644 /Library/LaunchDaemons/com.jamfsoftware.task.nosudocommand.plist 
/usr/sbin/chown root:wheel /Library/LaunchDaemons/com.jamfsoftware.task.nosudocommand.plist 
/bin/chmod 644 /Library/LaunchDaemons/com.jamfsoftware.task.accessremove.plist 
/usr/sbin/chown root:wheel /Library/LaunchDaemons/com.jamfsoftware.task.accessremove.plist 

##LOAD PLIST TIMER REMOVAL## 
launchctl load -w /Library/LaunchDaemons/com.jamfsoftware.task.nosudocommand.plist 
launchctl load -w /Library/LaunchDaemons/com.jamfsoftware.task.accessremove.plist 

exit 0 
