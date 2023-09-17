#!/bin/sh

mkdir -p $HOME/.local/share/bm

BOOKMARKS=$HOME/.local/share/bm/bookmarks
touch $BOOKMARKS

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
	options="$(echo $PWD) $(ls -d $PWD/*)"
	save_bookmark "$($options | $MENU)"
	;;

	-s)
	# save a bookmark from terminal
	save_bookmark "$2"
	;;

	-l)
	# list bookmarks in terminal
	cat $BOOKMARKS
	;;

	-t)
	# get bookmark in stdout
	xdotool type "$(cat $BOOKMARKS | $MENU)"
	;;

	*)
	# show help
	echo 'Usage:'
	echo '    bm [options] [<arguments>]'
	echo ''
	echo 'Options:'
	echo '    -c              bookmark data on the clipboard'
	echo '    -f              bookmark a file using dmenu'
	echo '    -s <bookmark>   bookmark from the terminal'
	echo '    -l              list all bookmarks in terminal'
	echo '    -t              type a bookmark from dmenu'
	
	;;
esac
