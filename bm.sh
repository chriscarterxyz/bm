#!/bin/sh

BOOKMARKS=/home/chris/.bookmarks
MENU='dmenu -i -l 50'

save_bookmark () {
	if grep -Fxq "$1" $BOOKMARKS
	then
		echo 'bookmark already exists';
	elif [ -z "$1" ]
	then
		echo 'bookmark is empty'
	else
		echo "$1" >> $BOOKMARKS;
		echo 'bookmarked' "$1"	
	fi
}

case "$1" in 
	-e)
	# edit bookmark file
	vim $BOOKMARKS
	;;

	-c)
	# save a bookmark from clipboard
	save_bookmark "$(xclip -selection c -o)"
	;;

	-f)
	# save a file
	selected_file="$(ls -d $PWD/* | $MENU)"
	save_bookmark "file://$selected_file"
	;;

	-s)
	# save a bookmark from terminal
	save_bookmark "$2"
	;;

	-l)
	# list bookmarks in terminal
	cat $BOOKMARKS
	;;

	-o)
	# get bookmark in stdout
	cat $BOOKMARKS | $MENU
	;;

	*)
	# show help
	echo 'Usage:\n\tbm [options] [<arguments>]'
	echo '\nOptions:'
	echo '\t-c              bookmark data on the clipboard'
	echo '\t-f              bookmark a file using dmenu'
	echo '\t-s <bookmark>   bookmark from the terminal'
	echo '\t-l              list all bookmarks in terminal'
	echo '\t-o              get a bookmark in stdout using dmenu'
	
	;;
esac
