#!/usr/bin/env bash

# A bash script to keep a Music Player Daemon playlist filled with
#   random songs.

## Define variables
### The location of the exclude file
FILE_EXCLUDE="/home/mpd/mpd-exclude.txt"
### The location of the include file
FILE_INCLUDE="/home/mpd/mpd-include.txt"
### How long the playlist should be
LINES_IDEAL="151"
### List of bash applications used
REQUIREMENTS="comm cut expr grep head mpc rev seq shuf sort tail wc"
### Temporary file location
TMP_FILE="/dev/shm/mpd-tmp.txt"

## Define functions

### Check for requirements
function check_requirements () {
  echo ""
  echo "Checking for requirements..."
  #### Loop through our list of required programs
  for REQUIREMENT in $REQUIREMENTS
    do
      ##### Try to run each program; use || to detect a failure
      which $REQUIREMENT || {
        echo "Requirement missing:" $REQUIREMENT
        exit 1
      }
    done  
  echo "Requirements met."
}

### Check if the include file exists and is readable
function check_include_file {
  if [ -r $FILE_INCLUDE ]
    then
      echo ""
      echo "Found include file:" $FILE_INCLUDE
    else
      ##### Create the include file if needed
      create_include_file $FILE_INCLUDE
  fi
}

### Create the include file if needed
function create_include_file () {
  echo ""
  echo "Creating missing include file:" $1
  mpc listall > $1
  #### Check to see if the file we made is there and writable
  if [ -w $1 ]
    then
      echo "Missing include file created; now sorting..."
      ##### Make sure to sort the file so we can use comm later
      sort $1 -o "$TMP_FILE"
      mv "$TMP_FILE" $1
    else
      echo "Unable to create missing include file!"
      exit 1
  fi
  #### Check if the exclude file exists, and use it if so
  if [ -r $FILE_EXCLUDE ]
    then
      echo "Found exclude file:" $FILE_EXCLUDE
      echo "Sorting exclude file..."
      ##### Make sure to sort the file so we can use comm later
      sort $FILE_EXCLUDE -o "$TMP_FILE"
      mv "$TMP_FILE" $FILE_EXCLUDE
      echo "Exclude file sorted."
      echo "Keeping lines unique to include file..."
      comm -23 $1 $FILE_EXCLUDE > "$TMP_FILE"
      mv "$TMP_FILE" $1
    else
      echo "No exclude file found at:" $FILE_EXCLUDE
      exit 1
  fi
}

### Enforce MPD options
function enforce_mpd_options () {
  echo ""
  echo "Enforcing MPD options."
  #### Enforce consume mode so played songs are removed automatically
  mpc -q consume on
  #### Make sure MPD is playing
  mpc play
}

### Choose a random number between one and the count of lines in the
###   include file
function choose_a_random_number () {
  echo ""
  echo "Choosing a random number between 1 and" $LINES_INCLUDE
  #### Use shuf to pick a single integer as needed
  LINE_ADD=$(shuf -i 1-$LINES_INCLUDE -n 1 )
  echo "Random number chosen:" $LINE_ADD
}

### Add a random folder/album
function add_a_random_folder () {
  choose_a_random_number
  #### head: list all the lines in the file up to our random number
  #### tail: from that list, keep only the last line
  #### rev: reverse the order of the line, putting the first character last
  #### cut: splitting by forward slashes, keep the 2nd field and beyond
  #### rev: reverse the order of the line, putting the last character first
  #### This finds a random line, then ignores the song part of the line,
  ####   keeping only the folder/album portion of the line.
  NEW_ALBUM=$(head -n $LINE_ADD $FILE_INCLUDE | tail -n 1 | rev | cut -d '/' -f2- | rev)
  echo "Adding this album to the playlist:" $NEW_ALBUM
  #### grep: find all the lines matching the folder we just picked
  #### head: don't add too many songs, if it's a larger folder
  for NEW_TRACK in $(grep $NEW_ALBUM $FILE_INCLUDE | head -n $(expr $LINES_IDEAL / 2))
    do
      if [ -n "$NEW_TRACK" ]
        then
          echo "Adding this song to the playlist:" $NEW_TRACK
          mpc add "$NEW_TRACK"
        else
          echo "Strange; we didn't come back with a file...   Skipping!"
      fi
    done
}

### Count the lines in the given file
function count_lines_in_given_file {
  echo "Counting lines in given file:" $1
  #### cut: just keep the count, not the filename
  LINES_INCLUDE=$(wc -l $1 | cut -f1 -d" ")
  echo "Number of lines counted:" $LINES_INCLUDE
}

### Count the lines in the current playlist
function count_lines_in_current_playlist {
  echo "Counting lines in current playlist..."
  LINES_PLAYLIST=$(mpc playlist | wc -l)
  echo "Number of lines in playlist:" $LINES_PLAYLIST
}

### Find the difference between the two current and ideal numbers
function perform_arithmetic {
  echo "Performing arithmetic..."
  LINES_DIFF=$(expr $LINES_IDEAL - $LINES_PLAYLIST)
  if [ $LINES_DIFF -gt 0 ]
    then
      echo "Number of lines to add:" $LINES_DIFF
    else
      echo "Nothing to add; plenty of songs in the playlist!"
      exit 0
  fi  
}

### Loop enough times to fill that difference
function loop_to_fill_difference {
  for LOOP in $(seq $LINES_DIFF)
    do
      choose_a_random_number
      #### Add the randomly chosen line to the MPD playlist as long as it's 
      ####   not empty
      #### head: list all the lines in the file up to our random number
      #### tail: from that long list, keep only the last line
      NEW_TRACK=$(head -n $LINE_ADD $FILE_INCLUDE | tail -n 1)
      if [ -n "$NEW_TRACK" ]
        then
          echo "Adding this song to the playlist:" $NEW_TRACK
          mpc add "$NEW_TRACK"
        else
          echo "Strange; we didn't come back with a file...   Skipping!"
      fi
    done
}

## Check for requirements
check_requirements

## Check if the include file exists, then create it if needed
check_include_file

## Enforce MPD options
enforce_mpd_options

## Count the lines in the given file
count_lines_in_given_file $FILE_INCLUDE

## Add a random folder/album
add_a_random_folder

## Show our goal
echo "Number of lines we are aiming for:" $LINES_IDEAL

## Find out how long the playlist is now
count_lines_in_current_playlist

## Find the difference between the two current and ideal numbers
perform_arithmetic

## Loop enough times to fill that difference
loop_to_fill_difference
