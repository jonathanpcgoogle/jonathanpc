#!/bin/bash
#Created by Jonathan

device_info=$(lsblk -o NAME,FSTYPE,TYPE,MOUNTPOINTS | grep crypt)
device_unformatted=$(echo $device_info | awk '{print $1}')
device_name=$(echo $device_unformatted | cut -c 7-100)
#fs_type=$(echo $device_info | awk '{print $2}')
#mount_point=$(echo $device_info | awk '{print $4}') 
current_status=$(cryptsetup luksDump /dev/$device_name)
current_user=$(users | awk '{print $1}') 
home_path=$(getent passwd $current_user | cut -d: -f6)
#touch $home_path/LUKSdump.txt
LAST_CHANGED=$(date -r $home_path/LUKSdump.txt)

# If a baseline doesn't exist, create it
if [ ! -f "$home_path/LUKSdump.txt" ]; then
   echo "$current_status" > "$home_path/LUKSdump.txt"
fi

# Check against baseline file 
if ! diff -q $home_path/LUKSdump.txt <(echo "$current_status"); then
   #echo "Potential password change detected!" | mail -s "Encryption Alert" jonathanpc@google.com
   echo "$current_status" > $home_path/LUKSdump.txt # Update baseline
   echo -e TRUE
      /opt/NinjaRMMAgent/programdata/ninjarmm-cli set CryptPwdLastChange "CHANGED   $LAST_CHANGED"
   echo "Passwd is Changed $LAST_CHANGED"
else 

  echo -e FALSE
      /opt/NinjaRMMAgent/programdata/ninjarmm-cli set CryptPwdLastChange "NOT_CHANGED   $LAST_CHANGED"
  echo "Passwd is Not Changed $LAST_CHANGED"
fi


#echo "Device: $device_name"
#echo "Filesystem Type: $fs_type"
#echo "Mount Point: $mount_point"


exit 0