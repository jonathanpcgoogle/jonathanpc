#!/bin/bash
# First, check if cryptsetup luks works with birth date
DISKENC0=$(lsblk -p --json | jq -r '.blockdevices[] | select(.children) | .children[] | select(.children) as $partition | .children[] | select(.type == "crypt") | $partition.name')
CRYPTKEY0=$(stat / | grep "Birth" | sed 's/Birth: //g' | cut -b 2-11)
RESULT0=$(printf "$CRYPTKEY0" | sudo cryptsetup luksOpen --test-passphrase $DISKENC0 && echo "TRUE")
PASSWORD0=$(openssl rand -base64 32)


if [ "$RESULT0" = "TRUE" ]; then
    # change the encryption key
    #echo "encryption key gets changed to $PASSWORD0"
    (echo $CRYPTKEY0; echo "$PASSWORD0"; echo "$PASSWORD0") | cryptsetup luksChangeKey $DISKENC0 --key-slot 0
    /opt/NinjaRMMAgent/programdata/ninjarmm-cli set lukskey $PASSWORD0
else
    # we can't change it
    echo nothing
fi
