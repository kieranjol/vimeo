#!/bin/bash
size=($(ffprobe -v error -select_streams v:0 -show_entries stream=height -of default=noprint_wrappers=1:nokey=1 "$1"))
wsize=($(ffprobe -v error -select_streams v:0 -show_entries stream=width -of default=noprint_wrappers=1:nokey=1 "$1"))

ycor=($(bc <<< $size/1.20))
xcor=($(bc <<< $wsize/2))
font=($(bc <<< $size/12))

textoptions=("fontsize=$font:x=$xcor-text_w/2:y=$ycor")
echo $textoptions



