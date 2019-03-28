#!/usr/bin/env sh
# This script will run offlineimap and check
# for new email if there is an internet connection.
#
# If it detects new mail, it uses mpv to play a
# notification sound: notify.opus
#
# I have this run as a cronjob every 5 minutes.

export DISPLAY=:0.0
logfile="$XDG_CONFIG_HOME"/mutt/etc/.offlineimap.log
logfile_old="$XDG_CONFIG_HOME"/mutt/etc/.offlineimap.log_old
FORCE=false

clear
[ -z "$logfile_old" ] && rm "$logfile_old"
mv "$logfile" "$logfile_old"
touch "$logfile"

TEMP=`getopt -o f -n 'mailsync.sh' -- "$@"`
eval set -- "$TEMP"

while true; do
  case "$1" in
    -f ) FORCE=true; shift ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done

# Checks for internet connection and set notification script.
if ! $FORCE; then
    ping -q -w 4 -c 1 1.1.1.1 >> "$logfile"
    if [ $? -ne 0 ]; then
        echo -e "\n[ERROR]: no internet connection or something is blocking the pings, use ESC-o or ESC-O to force\n" |
        tee -a "$logfile" &&
        read -n 1 -s -r -p "Press any key to continue" &&
        exit

    fi
    echo -e "\n-----------------------------------\n\n" >> "$logfile"
fi

# Settings are different for MacOS (Darwin) systems.
if [ "$(uname)" = "Darwin" ]
then
	notify() { osascript -e "display notification \"$2 in $1\" with title \"You've got Mail\" subtitle \"Account: $account\"" && sleep 2 ;}
else
	notify() { mpv --really-quiet ~/.config/mutt/etc/notify.opus & pgrep -x dunst && notify-send -i ~/.config/mutt/etc/email.gif "$2 new mail(s) in \`$1\` account." ;}
fi

echo " 🔃" > /tmp/imapsyncicon
pkill -RTMIN+12 i3blocks

accounts=$(ls "$XDG_DATA_HOME"/mail)

# Run offlineimap. You can feed this script different settings.
echo "$accounts" | xargs --max-procs=4 -n 1 offlineimap -l "$logfile" -o "$@" -a

[ $? -ne 0 ] &&
    echo -e "\n\n---------\nSomething went wrong, check this log file for Errors!\n---------\n" >> "$logfile" &&
    nvim -M + "$logfile"

rm -f /tmp/imapsyncicon
pkill -RTMIN+12 i3blocks

# Check all accounts/mailboxes for new mail. Notify if there is new content.
for account in $accounts
do
    #List unread messages newer than last mailsync and count them
    newcount=$(find "$XDG_DATA_HOME"/mail/"$account"/INBOX/new/ \
        -type f -newer ~/.config/mutt/etc/.mailsynclastrun 2> /dev/null | wc -l)

    if [ "$newcount" -gt "0" ]
    then
        notify "$account" "$newcount" &
    fi
done
notmuch new

#Create a touch file that indicates the time of the last run of mailsync
touch ~/.config/mutt/etc/.mailsynclastrun
