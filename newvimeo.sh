#!/bin/bash -x

b='-show_entries format_tags=timecode'
echo $b
IFS=: read -a timecode < <(ffprobe -v error "${b[@]}" -of default=noprint_wrappers=1:nokey=1 "$1")
echo "$timecode"

		