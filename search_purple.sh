#!/bin/bash

# modify the next four lines for your system
EMAIL="your@email.com"
PIDGIN_HOME="/home/user/.purple/logs/irc/irc_account@irc.oftc.net/\#osm-bot.chat"
AREA="Washington, United State"
SCRIPT_HOME="/home/user/bin"

cd $PIDGIN_HOME
CURRENT=`(ls -t | head -1)`

grep $AREA $CURRENT|grep "just started editing" >> /tmp/found.txt

while read line
do
	USR=`echo $line |sed -e '/.*osmbot.test. /s///' -e '/ just started.*/s///' -e 's/[\/&]/\\&/g'`
	USER=`echo "$USR" | sed -e 's/[\$\^\&]/\\\&/g'`
	
	if ! grep -q "$USER" $SCRIPT_HOME/newuser/newuser.txt
	then
		CHANGESET=`echo $line | sed -e '/.*changeset /s///'`
		echo "$USR" >> $SCRIPT_HOME/newuser/newuser.txt
		MUSR=`echo "$USER" | sed -e 's/ /%20/g' -e 's;^;http://openstreetmap.org/message/new/;'`
		echo -e "$MUSR" '\t' $CHANGESET >> /tmp/both.txt
	fi
done </tmp/found.txt


if test -e /tmp/both.txt; then
	mailx -s "New User" $EMAIL </tmp/both.txt
	rm /tmp/both.txt
fi

if test -e /tmp/found.txt; then
	rm /tmp/found.txt
fi

# NOTES Section

grep $AREA $CURRENT|grep "posted a new note near" >> /tmp/found2.txt

while read line
do
	USR=`echo $line |sed -e '/.*osmbot.test. /s///' -e '/ posted a new note.*/s///' -e 's/[\/&]/\\&/g'`
	CHANGESET=`echo $line|sed -e '/.*new note near .*http/s//http/' -e '/ \(.*\)/s///'`
	NOTE=`echo $line|sed -e 's/^.*(\"//' -e 's/..$//'`

	if ! grep -q "$CHANGESET" $SCRIPT_HOME/purple/changeset.txt
	then
		echo "$CHANGESET" >> $SCRIPT_HOME/purple/changeset.txt
		echo -e "$USR" '\t' $CHANGESET '\t' $NOTE >> /tmp/notes.txt
	fi
done </tmp/found2.txt


if test -e /tmp/notes.txt; then
	mailx -s "New Note" $SCRIPT_HOME </tmp/notes.txt
	rm /tmp/notes.txt
#	cat /tmp/notes.txt
fi

if test -e /tmp/found2.txt; then
	rm /tmp/found2.txt
#	cat /tmp/found2.txt

fi
