 #!/bin/bash

#Fetching Docker.dmg from the repo
curl -L --referer ";auto" https://download.docker.com/mac/stable/Docker.dmg > /private/var/EnterpriseManagement/Docker.dmg

#Mounting the file
hdiutil attach /private/var/EnterpriseManagement/Docker.dmg
cd /Volumes/Docker/

#Installing the file
cp -rf Docker.app ~/Applications/

#installer -pkg "Docker” -target /
hdiutil detach Docker
cd /
sudo open /Applications/Docker.app 

#Provide Admin access to the current user
sudo /usr/sbin/dseditgroup -o edit -a $currentUser -t user admin

#Permission to plist file to launch Daemon
cd /Library/LaunchDaemons/
chmod 777 com.docker.vmnetd.plist
launchctl load -Fw /Library/LaunchDaemons/com.docker.vmnetd.plist
cd /

#Mapping existing user's account to packaging account

ln -s /Users/$currentUser/ /Users/docker-package-user

#Permission to container docker.sock
currentUser=ls -l /dev/console | cut -d " " -f 4
cd /Users/$currentUser/Library/Containers/com.docker.docker/Data
chmod 777 docker.sock 
sudo Docker run hello-world

#Revoke admin access from current user
sudo /usr/sbin/dseditgroup -o edit -d $currentUser -t user admin

exit 0