# mpd

*mpd-fullauto.bash* is a bash script to help manage [Music Player Daemon](http://www.musicpd.org/), also known as MPD, and keep its playlist filled with random songs.

The script is designed to be called every hour or two from cron.  It first adds a randomly selected album (folder) and then fills the rest of the playlist with randomly selected songs.

*mpd-nope.bash* is a bash script to help remove unwanted songs from the include file for mpd-fullauto.bash.

The script is designed to be called whenever an unwanted song is playing.

*mpd-nope-cgi* is a CGI script to make it easier to call mpd-nope.bash.

## Requirements

The *mpd-fullauto.bash* script requires the following:

- [Music Player Daemon](http://www.musicpd.org/)
- The MPD client, [mpc](https://www.musicpd.org/clients/mpc/)
- [Kernel.org util-linux](https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/), such as:
  - rev
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

The *mpd-nope.cgi* script requires the following:

- *mpd-nope.bash* from above
- Packages:
  - apache2
  - libapache2-mod-fcgid
- `sudo a2enmod cgid`
- Had to make not just the `mpd-*clude.txt` files but the whole `/home/mpd` folder write-able by `www-data` (and everyone else) in order for `sed` to do its thing.

## Notes

As special characters like square brackets can interfere with `sed`, I recommend running a file and directory clean-up program such as [detox](https://linux.die.net/man/1/detox).

The important variables for operation of *mpd-fullauto.bash* are:

- FILE_EXCLUDE = The location of the exclude file
- FILE_INCLUDE = The location of the include file
- LINES_IDEAL = How long the playlist should be
- REQUIREMENTS = List of bash applications used
- TMP_FILE = Temporary file location

The important variables for operation of *mpd-nope.bash* are:

- FILE_EXCLUDE = The location of the exclude file
- FILE_INCLUDE = The location of the include file

No variables are needed for *mpd-nope.cgi*.

## Helpful links

- [Apache - Debian Wiki](https://wiki.debian.org/Apache)
- [CGI - Debian Wiki](https://wiki.debian.org/CGI)
- [Debian Policy Manual v4.5.1.0 » 11.5. Web servers and applications](https://www.debian.org/doc/debian-policy/ch-customized-programs.html#s-web-appl)
- [Apache Tutorial: Dynamic Content with CGI](https://httpd.apache.org/docs/2.4/howto/cgi.html)
