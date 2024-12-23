#!/bin/bash

GRR_INSTALL_FILE="/usr/lib/gagent/gagentd"
GRR_PACKAGE1="/etc/mycroft/cs_grr/fleetspeakd-mandiant-consulting-label_1.0-1_amd64.deb"
GRR_PACKAGE2="/etc/mycroft/cs_grr/fleetspeakd-alphabet-unlabeled_0.41-1_amd64.deb"
GRR_PACKAGE3="/etc/mycroft/cs_grr/gagent_3.4.6.8_amd64.deb"

# Check if GRR Agent is installed
if [ -f "$GRR_INSTALL_FILE" ]; then
    echo "GRR Agent is already installed."
else
    echo "Installing GRR agent..."
    sudo dpkg -i "$GRR_PACKAGE1"
    sudo dpkg -i "$GRR_PACKAGE2"
    sudo dpkg -i "$GRR_PACKAGE3"
    echo "GRR agent is now installed."

fi

# Check if GRR Agent is active (after potential installation)
GRRACTIVE=$(systemctl is-active fleetspeakd)

if [ "$GRRACTIVE" = "active" ]; then
    echo "GRR Agent is active."
else
    echo "Starting GRR Agent..."
    sudo  services falcon-sensor restart
    echo "GRR Agent is started."

fi

