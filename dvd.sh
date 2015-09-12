#!/bin/bash -x

sourcepath="$(dirname "$1")" 
filename="$(basename "$1")"
filenoext="${filename%.*}"

export VIDEO_FORMAT=PAL
ffmpeg -i "$1" -target pal-dvd "$1"_dvd.mpg
mkdir "$sourcepath/dvd"
dvdauthor -o "$sourcepath/dvd" -t "$1"_dvd.mpg
dvdauthor -o "$sourcepath/dvd" -T
mkisofs -dvd-video -V IFIARCHIVE -o "$1".iso "$sourcepath/dvd"


