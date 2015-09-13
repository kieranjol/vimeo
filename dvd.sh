#!/bin/bash 

sourcepath="$(dirname "$1")" 
filename="$(basename "$1")"
filenoext="${filename%.*}"

echo "Would you like to burn straight to DVD Y or N?"
read "burn";

export VIDEO_FORMAT=PAL
ffmpeg -i "$1" -target pal-dvd "$1"_dvd.mpg
mkdir "$sourcepath/$filenoext"
mkdir "$sourcepath/$filenoext/dvd"
dvdauthor -o "$sourcepath/$filenoext/dvd" -t "$1"_dvd.mpg
dvdauthor -o "$sourcepath/$filenoext/dvd" -T
mkisofs -dvd-video -V IFIARCHIVE -o "$1".iso "$sourcepath/$filenoext/dvd"

if [[ "${burn}" == "Y" || "${burn}" == "y" ]] ; then
	hdiutil burn "$1".iso
else
	exit
fi