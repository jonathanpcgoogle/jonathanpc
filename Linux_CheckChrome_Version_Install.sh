#!/bin/bash

chromefunction1()
{

if [ -f /usr/bin/google-chrome ]; then

# Chrome stable public Version checks
        chromepublic_version=$(wget -qO- https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm | head -c96 | strings | rev | awk -F"[:-]" '/emorhc/ { print $2 }' | rev)

# Chrome stable installed Version checks
        chromeinstalled_version=$(google-chrome --version | awk '{print $3}')

        echo "Google Chrome is in Latest version"
        echo $chromepublic_version
        echo $chromeinstalled_version
        /opt/NinjaRMMAgent/programdata/ninjarmm-cli set chromeinstalledversion $chromeinstalled_version
else

    chromefunction2

fi
}

chromefunction2()
{
        
# Install latest version of chrome
#        echo "Chrome needs to upgrade to latest version"
        echo "Installing Google Chrome" &&
        wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb &&
        sudo dpkg -i google-chrome-stable_current_amd64.deb &&
        rm -f google-chrome-stable_current_amd64.deb
        echo "Chrome upgraded to latest version"
        chromeinstalled_version=$(google-chrome --version | awk '{print $3}')
        /opt/NinjaRMMAgent/programdata/ninjarmm-cli set chromeinstalledversion $chromeinstalled_version
}


# Compare chrome versions and installs it if required
if [ "$chromepublic_version"=="$chromeinstalled_version" ]; then
      
        chromefunction1

fi

exit 0
