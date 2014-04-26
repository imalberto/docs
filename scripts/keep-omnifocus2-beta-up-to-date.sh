#!/bin/zsh -f


# Where do you want OmniFocus to be installed to?
# INSTALL_TO="/Applications/OmniFocus.app"
INSTALL_TO=~/Desktop/Apps\ \(Trial\)/OmniFocus.app



# Purpose: install latest version of OmniFocus
#
# From:	Tj Luo.ma
# Mail:	luomat at gmail dot com
# Web: 	http://RhymesWithDiploma.com
# Date:	2014-04-25

NAME="$0:t:r"

zmodload zsh/datetime

timestamp () {
	strftime "%Y-%m-%d at %H:%M:%S" "$EPOCHSECONDS"
}

LOG="$HOME/Library/Logs/$NAME.log"

NOTIFY='yes'

# 'msg' =
# if terminal-notifier is installed, use that
# if growlnotify is installed AND growl is running, use that
# otherwise 'msg' is mostly just 'echo' with the timestamp that also goes to $LOG

if (( $+commands[terminal-notifier] ))
then
	function msg {
		echo "$NAME [`timestamp`]: $@" | tee -a "$LOG"

		if [ "$NOTIFY" = "yes" ]
		then
			terminal-notifier \
				-sender com.omnigroup.OmniFocus2 \
				-group "$NAME" \
				-message "$@" \
				-title "$NAME at `timestamp`" 2>&1 | tee -a "$LOG"
		fi
	}

elif (( $+commands[growlnotify] ))
then
	function msg {
		echo "$NAME [`timestamp`]: $@" | tee -a "$LOG"

		if [ "$NOTIFY" = "yes" ]
		then
			# we only run growlnotify if Growl.app is already running
			pgrep -xq Growl && \
				growlnotify  \
					--appIcon "OmniFocus"  \
					--identifier "$NAME"  \
					--message "$@"  \
					--title "$NAME at `timestamp`" 2>&1 | tee -a "$LOG"
		fi
	}

else
	function msg {	echo "$NAME [`timestamp`]: $@" | tee -a "$LOG" }
fi


die ()
{
	msg "$@"
	exit 1
}


# get the most recent build number
MOST_RECENT=`curl -sfL 'http://omnistaging.omnigroup.com/omnifocus-2/' | tr '"|>|<' '\012' | egrep '\.dmg' | head -1 | sed 's#-Test.dmg##g; s#.*-r##g'`

# make sure we got _something_ at least
if [ "$MOST_RECENT" = "" ]
then
	die "Unable to determine most recent version (MOST_RECENT is empty)"
	exit 1
fi

# if we find an installed version, check to see if we are up to date
if [ -e "$INSTALL_TO" ]
then
	# get the currently installed version
	INSTALLED=`defaults read "$INSTALL_TO/Contents/Info.plist" CFBundleVersion 2>/dev/null | cut -d . -f 3`

	# if the installed version is greater than or equal to the most recent version
	# then we are up to date
	if [[ "$INSTALLED" -ge "$MOST_RECENT" ]]
	then
			# don't show a visual indicator when we ARE up to date.
			# that's just distracting for no reason
			# just log it
			NOTIFY='no'
			msg "OmniFocus is up to date"
			exit 0
	fi

	msg "OmniFocus is out of date ($INSTALLED vs $MOST_RECENT). Downloading newest version."
else
	msg "OmniFocus is not installed at $INSTALL_TO. Downloading newest version."
fi

FILENAME="$HOME/Downloads/OmniFocus-2-beta-${MOST_RECENT}.dmg"

curl -sL -o "$FILENAME" "http://omnistaging.omnigroup.com/omnifocus-2/releases/OmniFocus-2-r${MOST_RECENT}-Test.dmg" ||\
die "Failed to download $FILENAME:t"

EXIT="$?"

if [ "$EXIT" != "0" ]
then
		die "curl of $FILENAME failed"
		exit 1
fi


# Mount the DMG without showing it
MNTPNT=$(echo -n "Y" | hdid -nobrowse -plist "$FILENAME" 2>/dev/null | fgrep -A 1 '<key>mount-point</key>' | tail -1 | sed 's#</string>.*##g ; s#.*<string>##g')



if [ "$MNTPNT" = "" ]
then
		die "MNTPNT is empty for $FILENAME"
		exit 1
fi

LAUNCH=no

# If the app is running, ask it, nicely, to quit
pgrep -x OmniFocus && LAUNCH=yes && osascript -e 'tell application "OmniFocus" to quit' && sleep 5

# if it is still running, we can't keep going
pgrep -x OmniFocus && die "OmniFocus did not quit"

# is there a version already installed?
if [ -e "${INSTALL_TO}" ]
then
		# if yes, move it to the trash
		mv -vf "${INSTALL_TO}" "$HOME/.Trash/OmniFocus-$INSTALLED.app"
fi

# if there is still something where we want to install this file
# then we can't continue
if [ -e "${INSTALL_TO}" ]
then
		die "Could not remove existing ${INSTALL_TO}"
		exit 1
fi

# copy the app to wherever it is supposed to be installed
ditto -v "$MNTPNT/OmniFocus.app" "${INSTALL_TO}" || die "Installation of $MNTPNT/OmniFocus.app failed"

# unmount the DMG
diskutil unmount "$MNTPNT"

# Remove the "do you really wanna open this?" warning
xattr -d com.apple.quarantine "$INSTALL_TO"

if [ "$LAUNCH" = "no" -a "$INSTALLED" != "" ]
then
		# If this is the first time the app is being installed, launch it
		# if we do not need to launch the app
		# because it wasn't running when we started this
		# then just note that the update was successful
		msg "Upgraded OmniFocus to version $MOST_RECENT"
		exit 0
fi

if [ "$INSTALLED" = "" ]
then
	# if this is the first time the app has been installed, run it in the foreground
	open -b com.omnigroup.OmniFocus2

else
	# if we are just re-launching it, do that in the background

	open --hide -b com.omnigroup.OmniFocus2
fi

# Move the DMG to the trash
mv -f "$FILENAME" "$HOME/.Trash/"

exit
#
#EOF
