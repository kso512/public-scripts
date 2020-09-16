#!/usr/bin/env bash

# A bash script to keep a Music Player Daemon playlist filled with
#   random songs.

## Define variables
### The location of the include file
FILE_INCLUDE="/home/mpd/mpd-include.txt"
### How long the playlist should be
LINES_IDEAL="151"

## Create the include file if needed
if [ -r $FILE_INCLUDE ]
  then
    echo "Found include file:" $FILE_INCLUDE
  else
    if [ $(which mpc) ]
      then
        echo "Creating missing include file:" $FILE_INCLUDE
        if [ $(mpc listall > $FILE_INCLUDE) ]
          then
            echo "Missing include file created."
          else
            echo "Unable to create missing include file!"
            exit 1
        fi
      else
        echo "Unable to find include file and unable to make one because mpc is missing!"
        exit 1
    fi
fi

## Enforce consume mode so played songs are removed automatically
if [ $(which mpc) ]
  then
    echo "Enforcing consume mode."
    mpc -q consume on
  else
    echo "Unable to enforce consume mode because mpc is missing!"
    exit 1
fi

## Count the lines in the include file
if [ $(which wc) ]
  then
    if [ $(which cut) ]
      then
        echo "Counting lines in include file:" $FILE_INCLUDE
        LINES_INCLUDE=$(wc -l $FILE_INCLUDE | cut -f1 -d" ")
        echo "Number of lines counted:" $LINES_INCLUDE
      else
        echo "Unable to count lines in include file because cut is missing!"
        exit 1
    fi
  else
    echo "Unable to count lines in include file because wc is missing!"
    exit 1
fi

## Find out how long the playlist is now
if [ $(which mpc) ]
  then
    if [ $(which wc) ]
      then
        echo "Counting lines in current playlist..."
        LINES_PLAYLIST=$(mpc playlist | wc -l)
        echo "Number of lines in playlist:" $LINES_PLAYLIST
      else
        echo "Unable to count lines in current playlist because wc is missing!"
        exit 1
    fi
  else
    echo "Unable to count lines in current playlist because mpc is missing!"
    exit 1
fi

## Find the difference between the two current and ideal numbers
if [ $(which expr) ]
  then
    echo "Performing arithmetic..."
    LINES_DIFF=$(expr $LINES_IDEAL - $LINES_PLAYLIST)
    if [ $LINES_DIFF -gt 1 ]
      then
        echo "Number of lines to add:" $LINES_DIFF
      else
        echo "Nothing to add; plenty of songs in the playlist!"
        exit 0
    fi  
  else
    echo "Unable to perform arithmetic because expr is missing!"
    exit 1
fi

## Loop enough times to fill that difference
for LOOP in $(seq $LINES_DIFF)
  do
    ### Choose a random number between one and the count of lines in the 
    ###   include file
    if [ $(which shuf) ]
      then
        echo "Choosing a random number..."
        LINE_ADD=$(shuf -i 1-$LINES_INCLUDE -n 1 )
        echo "Random number chosen:" $LINE_ADD
      else
        echo "Unable to pick a random number because shuf is missing!"
        exit 1
    fi
    ### Add the randomly chosen line to the MPD playlist as long as it's 
    ###   not empty
    if [ $(which head) ]
      then
        if [ $(which tail) ]
          then
            NEW_TRACK=$(head -n $LINE_ADD $FILE_INCLUDE | tail -n 1)
            if [ -n "$NEW_TRACK" ]
              then
                echo "Adding this song to the playlist:" $NEW_TRACK
                mpc add "$NEW_TRACK"
              else
                echo "Strange; we didn't come back with a file...   Skipping!"
            fi
          else
            echo "Unable to pick a random song because tail is missing!"
            exit 1
        fi
      else
        echo "Unable to pick a random song because head is missing!"
        exit 1
    fi
  done