# Linux-Maintenance-Script
Maintaining system binaries

The maintenance.sh script automates package updates and upgrades for
 Debian/Redhat/Arch -based Linux distributions by detecting which packagemanager is 
 installed (apt,dnf or pacman) and runs the corresponding functions to update, upgrade,
 and autoremove/autoclean packages on a regular basis (weekly). It also enables
 Wifi if it was disabled before running the script. The script logs all output to
 a log file located in /var/log/last_maintenance.log for inspection.

If you want more information about the functions used, check out their respective
 man pages: `man apt-get`, `man dnf`, and `man pacman`.

To use the maintenance.sh script, follow these steps:

1. Make the script executable by running `chmod +x maintenance.sh` in your
    terminal.
2. Set up a cron job to run it on a regular basis (e.g., every week) using
    the command `crontab -e`.
3. Add the following line at the end of the crontab file: `@weekly
    /path/to/maintenance.sh` (replace `/path/to/` with the actual path
    to maintenance.sh).
4. Save and exit the crontab file.
5. Verify that the script is running by checking the contents of the log file
    (`/var/log/last_maintenance.log`).
6. If you want to run the script manually, simply execute it in your terminal
    with `./maintenance.sh`.

Note: The script will only run if it has not been modified within 24 hours
        of the last modification time. This is to prevent unnecessary maintenance
        runs.
