# mpd

*mpd-fullauto.bash* is a bash script to help manage [Music Player Daemon](http://www.musicpd.org/), also known as MPD, and keep its playlist filled with random songs.

The script is designed to be called every 5 minutes from cron.

*mpd-nope.bash* is a bash script to help remove unwanted songs from the include file for mpd-fullauto.bash.

The script is designed to be called whenever an unwanted song is playing.

## Requirements

The *mpd-fullauto.bash* script requires the following:

- [Music Player Daemon](http://www.musicpd.org/)
- The MPD client, [mpc](https://www.musicpd.org/clients/mpc/)
- [GNU core-utils](https://www.gnu.org/software/coreutils/manual/coreutils.html), such as:
  - cut
  - expr
  - head
  - shuf
  - tail
  - wc

The *mpd-nope.bash* script requires the following:

- [Music Player Daemon](http://www.musicpd.org/)
- The MPD client, [mpc](https://www.musicpd.org/clients/mpc/)
- [GNU sed](https://www.gnu.org/software/sed/manual/sed.html)
- [GNU core-utils](https://www.gnu.org/software/coreutils/manual/coreutils.html), such as:
  - cut
  - wc

## Notes

The important variables for operation of *mpd-fullauto.bash* are:

- FILE_INCLUDE = The location of the include file
- LINES_IDEAL = How long the playlist should be

The important variables for operation of *mpd-nope.bash* are:

- FILE_INCLUDE = The location of the include file
