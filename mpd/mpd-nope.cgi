#!/bin/bash

echo "Content-type: text/html"

echo ""

echo "<html><head><title>mpd-nope.bash</title></head><body>"

echo "<h1>mpd-nope.bash</h1>"

echo "<p>Today is $(date)</p>"
echo "<p>I am user $(whoami)</p>"

echo "<p>Running mpd-nope.bash...</p>"
echo "<pre><code>$(/home/mpd/mpd-nope.bash)</code></pre>"

echo "<p><a href=\"/cgi-bin/mpd-nope.cgi\">RELOAD</a></p>"

echo "</body></html>"
