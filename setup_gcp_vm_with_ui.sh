#!/bin/bash

# Unfortunately, the Gmail API does not allow initial authentication from a script/headless environment. 
# This authentication must be performed in an environment where a browser can be accessed to accept
# a license agreement. This script is to be run on a default Debian Linux distro on the Google Compute Engine.
# You MUST run these from the SSH screen afforded to you in the GCP UI.
# There are manual steps to follow afterwards. They're described as they come up.

wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
sudo apt update -y
sudo dpkg --install chrome-remote-desktop_current_amd64.deb
sudo apt install --assume-yes --fix-broken
sudo DEBIAN_FRONTEND=noninteractive     apt install --assume-yes xfce4 desktop-base
echo "xfce4-session" > ~/.chrome-remote-desktop-session
sudo apt install --assume-yes xscreensaver
sudo apt install --assume-yes task-xfce-desktop
sudo systemctl disable lightdm.service
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg --install google-chrome-stable_current_amd64.deb
sudo apt install --assume-yes --fix-broken
sudo passwd

# Finally, some manual steps offered by Google:
# https://cloud.google.com/solutions/chrome-desktop-remote-on-compute-engine

