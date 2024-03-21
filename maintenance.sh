#!/bin/bash

# Copyright (c) [2023] [Thomas Pirchmoser] 
#   see LICENSE.TXT

# maintenance.sh--a script for maintaining system packages for Debian and Red Hat 
#                 based Distros. Can be automated with "sudo crontab -u root -e"
#                 or run directly in the terminal.

# Functions to update and upgrade etc. packages depending on the 
# packagemanager that is installed.
debian () {
    # Update and upgrade.  
    echo "      ***update***" >> $log_file
    apt-get update >> $log_file 2>&1 
    if [ $? -eq 0 ]; then
        echo "" >> $log_file 
        echo "      ***upgrade***" >> $log_file 
        apt-get upgrade -y >> $log_file 2>&1
        if [ $? -eq 0 ]; then
            echo "" >> $log_file 
            echo "      ***autoremove***" >> $log_file 
            apt-get autoremove -y >> $log_file 2>&1 
            echo "" >> $log_file 
            echo "      ***autoclean***" >> $log_file 
            apt-get autoclean >> $log_file 2>&1
        fi
    else
        echo "      ***update failed***" >> $log_file 
    fi
}

red_hat () {
    # Update system packages. 
    echo "      ***update***" >> $log_file 
    dnf update -y >> $log_file 2>&1 
    if [ $? -eq 0 ]; then
        echo "" >> $log_file 
        echo "      ***upgrade***" >> $log_file 
        dnf upgrade -y >> $log_file 2>&1 
    else
        echo "      ***update failed***" >> $log_file 
    fi
}

arch () {
    # Upgrade system packages.
    echo "      ***update&upgrade***" >> $log_file 
    pacman -Syu --noconfirm >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "" >> $log_file 
    else
        echo "      ***update failed***" >> $log_file 
    fi
}

# Set color variables for messages
red='\033[0;31m'
green='\033[0;32m'
clear_color='\033[0m'

# Assign the path of the log-file to the variable log_file.
log_file=/var/log/last_maintenance.log

# Check if last_maintenance.log has been modified less than 24 hours ago and 
# exit the script if true, otherwise continue.
if [ -f "/var/log/last_maintenance.log" ]; then
    modified=$(find /var/log/ -mtime -1 -name "last_maintenance.log")
    if [ "$modified" != "" ]; then 
        info="${green}---> The system packages have been recently maintained! <---${clear_color}"
        echo -e "    ${info}" >> $log_file 2>&1
        sleep 0.5
        exit 0
    fi
fi

# Check if Wifi is disabled, if yes, enable Wifi.
connection=$(nmcli radio wifi)
if [ "$connection" = "disabled" ]; then 
    nmcli radio wifi on
    sleep 5 
fi

# Write to log file
echo "Last maintenance was done at:" >> $log_file
date >> $log_file 2>&1
echo "" >> $log_file

# Call the corresponding function based on the packagemanager installed.
if [ -x /bin/apt-get ] || [ -x /usr/bin/apt-get ]; then
    debian
elif [ -x /bin/dnf ]; then
    red_hat
elif [ -x /bin/pacman ]; then
    arch
else 
    echo "      ***No supported packagemanager found***" >> $log_file
fi

# If Wifi was turned on by the script, turn it off.
if [ "$connection" = "enabled" ] || [ "$connection" = "unknown" ]; then 
    nmcli radio wifi off
fi 
