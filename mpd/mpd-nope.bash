#!/usr/bin/env bash

# A bash script to keep Music Player Daemon from playing the currently
#   playing song again, if added by mpd-fullauto.bash.

## Define variables
### The location of the include file
FILE_INCLUDE="/home/mpd/mpd-include.txt"

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
    sed -i 's~'"$CURRENT_SONG"'~~g' $FILE_INCLUDE
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
