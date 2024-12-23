#!/bin/bash

device=$(lsblk -p --json | jq -r '.blockdevices[] | select(.children) | .children[] | select(.children) as $partition | .children[] | select(.type == "crypt") | $partition.name')
slot_num=$(sudo cryptsetup luksDump $device | grep "luks2" | awk '{print $1}' | cut -d: -f1 | tail -c 2)

# wipe all slots
cryptsetup erase $device
echo $slot_num

if [ $slot_num=="" ];then
    		echo "LUKS slots wiped"
        # Writing to Custom Field
        /opt/NinjaRMMAgent/programdata/ninjarmm-cli set luks2slot SlotsWiped
#      	shutdown -r now
fi

