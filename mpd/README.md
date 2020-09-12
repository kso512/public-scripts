# mpd

*mpd-fullauto.bash* is a bash script to help manage [Music Player Daemon](http://www.musicpd.org/), also known as MPD, and keep its playlist filled with random songs.

The script is designed to be called every 5 minutes from cron.

## Requirements

The *mpd-fullauto.bash* script requires the following:

- [Music Player Daemon](http://www.musicpd.org/)
- The MPD client, [mpc](https://www.musicpd.org/clients/mpc/)

## Notes

The important variables for operation of *mpd-fullauto.bash* are:

- FILE_INCLUDE = The location of the include file
- LENGTH_PLAYLIST = How long the playlist should be
