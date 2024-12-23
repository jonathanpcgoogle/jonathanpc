#!/bin/bash
mkdir -p /etc/mycroft/notifications
# Deploying the notify script (remove any previous entry)
if [ -d /etc/mycroft/notifications ]; then
  echo "Directory Exists"
rm -rf /etc/mycroft/notifications/notification.sh
cat << 'EOS' > /etc/mycroft/notifications/notification.sh
#!/bin/bash
# Check if the notification-daemon is installed
REQUIRED_PKG="notification-daemon"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
  echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
  sudo apt-get --yes install $REQUIRED_PKG
fi

# Check if the dbus-x11 is installed
REQUIRED_PKG="dbus-x11"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
  echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
  sudo apt-get --yes install $REQUIRED_PKG
fi

# Check if required dbus Notifications file exists and if not create it
CHECKFILE="/usr/share/dbus-1/services/org.freedesktop.Notifications.service"
CHECKDIR=$( dirname "$CHECKFILE" )

# The directory with the file must exist
mkdir -p "$CHECKDIR"
if [ ! -f "$CHECKFILE" ]; then
cat <<EOF >$CHECKFILE
[D-BUS Service]
Name=org.freedesktop.Notifications
Exec=/usr/lib/notification-daemon/notification-daemon
EOF
fi

# Get first user name of system (id 1000)
uid=$(id -nu 1000)

# Notification Directories and clearing after 1 hour
NOTDIR="/etc/mycroft/notifications/"
if [ -d $NOTDIR ]; then
    find $NOTDIR -name "*.id*" -type f -mmin +120 -delete
else
    mkdir -p $NOTDIR
    chmod -R 777 $NOTDIR
fi

# Only if uptime is >= 28 days
MAX_UPTIME=$((2419200 / 60 / 60 / 24))  # 28 days

# Only if uptime is >= 20 days
MAX_UPTIME2=$((1728000 / 60 / 60 / 24))  # 20 days

# Only if uptime is >= 25 days
MAX_UPTIME3=$((2160000 / 60 / 60 / 24))  # 25 days



# Get the real uptime
#current_uptime_c=$(awk '{print $1}' /proc/uptime) 
current_uptime_c=$(awk '{print $1}' /home/jonathan/Downloads/testuptime)
current_uptime=$(echo $current_uptime_c / 60 /60 / 24 | /usr/bin/bc)
uptime_days=$(echo $current_uptime_c / 60 / 60 / 24 | /usr/bin/bc)
days_remaining=$(($MAX_UPTIME - $uptime_days))

# Check if a reboot is necessary
#NOTIFICATION_UPTIME_DAYS=1
#MAX_UPTIME_DAYS=2
REBOOT_DELAY_MINUTES=60
NOTIFICATION_INTERVAL=10
#countdown_start=$(date +%s)
remaining_minutes=$REBOOT_DELAY_MINUTES
rem_minutes=$REBOOT_DELAY_MIN
# Calculate the reboot time
#reboot_time=$(( $countdown_start + ($REBOOT_DELAY_MINUTES * 60) ))

#Notification on the 20 and 25 day uptime
send_countdown_notifications() {

if [ $current_uptime -ge $MAX_UPTIME3 ]; then
# Notification popup2
    sudo -i -u $uid notify-send --icon=emblem-important --urgency=critical "Paradox REBOOT" "Your device uptime is > $uptime_days days. Reboot your device asap! if not, system will enforce reboot in $days_remaining days." 
    echo "Notification for 25 days uptime send to endusers device."

elif [ $current_uptime -ge $MAX_UPTIME2 ]; then
# Notification popup1
    sudo -i -u $uid notify-send --icon=emblem-important --urgency=critical "Paradox REBOOT" "Your device uptime is > $uptime_days days. Reboot your device asap! if not, system will enforce reboot in $days_remaining days." 
    echo "Notification for 20 days uptime send to endusers device."

fi

echo "Current uptime is $current_uptime days"

}

#Notification on the 28 day uptime and enforce reboot
if [ $current_uptime -ge $MAX_UPTIME ] && [ -f /etc/mycroft/notifications/notification.id3 ]; then

    VALUE=$(cat /etc/mycroft/notifications/notification.id3) 
# Countdown loop
        while [ $remaining_minutes -ge 1 ]; do 
            sudo -i -u $uid notify-send --icon=system-reboot --urgency=critical  "Paradox REBOOT" "Your device uptime is > $uptime_days days. System is enforcing reboot in $remaining_minutes minutes..."  --replace-id=$VALUE
            sleeptime=$(($NOTIFICATION_INTERVAL * 60))
            sleep $sleeptime # Sleep for the interval (in seconds)
            remaining_minutes=$(($remaining_minutes - $NOTIFICATION_INTERVAL))
        done
    sleep 5
    sudo -i -u $uid notify-send --icon=system-reboot --urgency=critical "Rebooting Now" "Your system is rebooting now...!"
    echo "System is rebooting now..."
    sudo /sbin/reboot
    
else
    echo "1" > /etc/mycroft/notifications/notification.id3

    send_countdown_notifications

fi

EOS

echo "Script added to the file"
chmod +x /etc/mycroft/notifications/notification.sh
# Add Cron-job, but only if it doesn't exist, yet
NOTIFY="/etc/mycroft/notifications/notification.sh"
CRON=$(crontab -l | grep "$NOTIFY" | head -n1)
if [[ $CRON != *"$NOTIFY"* ]]; then
        echo "Cronjob not exists"
        # It is not there, let's add it
        (crontab -l 2>/dev/null; echo "0 * * * * /etc/mycroft/notifications/notification.sh") | crontab -  
        echo "Cronjob added"
else
        # It is there, keep calm
        # Remove all older versions
        CRONFULL=$(crontab -l | grep -v "notification.sh")
        # Clear Crontab
        crontab -r
        # Fill Crontab without notification.sh keeping everything else
        (crontab -l 2>/dev/null; echo "$CRONFULL") | crontab -
        # Re-add notification.sh
        (crontab -l 2>/dev/null; echo "0 * * * * /etc/mycroft/notifications/notification.sh") | crontab -
        echo "Cronjob exists, readding it"
fi

fi
