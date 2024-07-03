#!/bin/sh

mkdir -p "$HOME"/.local/share/bm
BOOKMARKS="$HOME"/.local/share/bm/bookmarks
touch "$BOOKMARKS"

CACHEDIR="$HOME"/.cache/bm
mkdir -p "$CACHEDIR"

MENU='dmenu -i -nb #191724 -nf #908caa -sb #1f1d2e -sf #e0def4 -l 30'

save_bookmark () {
	if cat "$BOOKMARKS" | cut -f 1 | grep -Fxq "$1"
	then
		echo 'bookmark already exists';
	elif [ -z "$1" ]
	then
		echo 'bookmark is empty'
	else
		tempfile="$CACHEDIR"/.bm.txt
		touch "$tempfile"
		echo "" >> "$tempfile"
		echo "# Enter a description for bookmark $1. Lines beginning with # will be ignored." >> "$tempfile"
		st -e vim "$tempfile"
		cleaned_entry=$(cat "$tempfile" | sed -e '/^#/d' | tr '\n' ' ' | tr -s ' ')
		if [ -z "$cleaned_entry" ]
		then
			echo -e "$1 " >> "$BOOKMARKS";
		else
			echo -e "$1 # "$cleaned_entry"" >> "$BOOKMARKS";
		fi
		rm "$tempfile"
		echo 'bookmarked' "$1"	
	fi
}

case "$1" in 
	-e)
	# edit bookmark file
	vim "$BOOKMARKS"
	;;

	-c)
	# save a bookmark from clipboard
	save_bookmark "$(xclip -selection c -o)"
	;;

	-f)
	# save a file
	save_bookmark "$(ls -d "$PWD"/* | $MENU)"
	;;

	-s)
	# save a bookmark from terminal
	save_bookmark "$2"
	;;

	-l)
	# list bookmarks in terminal
	less -F "$BOOKMARKS"
	;;

	-t)
	# type a bookmark with dmenu
	bookmark="$(cat "$BOOKMARKS" | $MENU)"
	xdotool type "$( echo "$bookmark" | cut -f 1 -d' ')"
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
