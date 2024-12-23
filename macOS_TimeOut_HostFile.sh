#!/bin/bash

killall Terminal

chmod 666 /etc/hosts
#while true; do echo -ne "`date +%H:%M:%S:%N`\r";done
osascript -e 'display alert "Message!" message "You have only 6 Minutes time to edit the Host File. \n \n \t \t Press 'OK' to continue \n \n Press 'E' to edit the file once the Terminal launched."'

osascript <<'EOF'
tell application "Terminal"
    activate
    do script ("vi /etc/hosts") in window 1
end tell
EOF
sleep 30;

osascript -e 'display notification "1 minute is getting over, closing the Terminal now"'
sleep 10;

chmod 644 /etc/hosts

killall Terminal

exit 0