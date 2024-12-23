#!/bin/bash

FALCON_INSTALL_FILE="/opt/CrowdStrike/falconctl"
FALCON_PACKAGE="/etc/mycroft/cs_grr/falcon-sensor_7.14.0-16703_amd64.deb"

# Check if Falcon is installed
if [ -f "$FALCON_INSTALL_FILE" ]; then
    echo "Falcon is already installed."
else
    echo "Installing Falcon sensor..."
    sudo dpkg -i "$FALCON_PACKAGE"
    echo "Falcon is now installed."
    sudo  /opt/CrowdStrike/falconctl -s --cid=<Key> -f
    sudo  /opt/CrowdStrike/falconctl -s --tags="<gTag>"
    echo "Falcon is now labeled"
fi

# Check if Falcon is active (after potential installation)
CSACTIVE=$(systemctl is-active falcon-sensor)

if [ "$CSACTIVE" = "active" ]; then
    echo "Falcon is active."
else
    echo "Starting Falcon sensor..."
    sudo systemctl start falcon-sensor.service
    echo "Falcon sensor started."

fi

