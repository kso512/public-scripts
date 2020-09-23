#!/usr/bin/env bash

# A bash script to keep Music Player Daemon from playing the currently
#   playing song again, if added by mpd-fullauto.bash.

## Define variables
### The location of the include file
FILE_INCLUDE="/home/mpd/mpd-include.txt"

## Count the lines in the include file before our work
if [ $(which wc) ]
  then
    if [ $(which cut) ]
      then
        echo "Counting lines in include file before our work:" $FILE_INCLUDE
        LINES_INCLUDE_BEFORE=$(wc -l $FILE_INCLUDE | cut -f1 -d" ")
        echo "Number of lines counted:" $LINES_INCLUDE_BEFORE
      else
        echo "Unable to count lines in include file because cut is missing!"
        exit 1
    fi
  else
    echo "Unable to count lines in include file because wc is missing!"
    exit 1
fi

## Find out what the currently playing song is
if [ $(which mpc) ]
  then
    echo "Querying current song..."
    CURRENT_SONG=$(mpc current -f %file%)
    echo "Current song is:" $CURRENT_SONG
  else
    echo "Unable to query current song because mpc is missing!"
    exit 1
fi

## Remove that line from the include file
if [ $(which sed) ]
  then
    echo "Removing current song from include file..."
    # We are using "~" instead of "/" because it's used in the
    #   CURRENT_SONG variable, plus using single and double quotes
    #   in series
    sed -i '\~'"$CURRENT_SONG"'~d' $FILE_INCLUDE
  else
    echo "Unable to remove a line from include file because sed is missing!"
    exit 1
fi

## Jump to the next song
if [ $(which mpc) ]
  then
    echo "Jumping to next song..."
    mpc next
  else
    echo "Unable to jump to next song because mpc is missing!"
    exit 1
fi

## Count the lines in the include file after our work
if [ $(which wc) ]
  then
    if [ $(which cut) ]
      then
        echo "Counting lines in include file after our work:" $FILE_INCLUDE
        LINES_INCLUDE_AFTER=$(wc -l $FILE_INCLUDE | cut -f1 -d" ")
        echo "Number of lines counted:" $LINES_INCLUDE_AFTER
      else
        echo "Unable to count lines in include file because cut is missing!"
        exit 1
    fi
  else
    echo "Unable to count lines in include file because wc is missing!"
    exit 1
fi
