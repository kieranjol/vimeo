#!/bin/bash -x



echo "do you just want an SD bitc h264 Say Y or N?"
read bitc
if [[ "${bitc}" == "Y" || "${bitc}" == "y" ]] ; then


	size=($(ffprobe -v error -select_streams v:0 -show_entries stream=height -of default=noprint_wrappers=1:nokey=1 "$1"))
	wsize=($(ffprobe -v error -select_streams v:0 -show_entries stream=width -of default=noprint_wrappers=1:nokey=1 "$1"))

	ycor=($(bc <<< $size/1.20))
	xcor=($(bc <<< $wsize/2))
	font=($(bc <<< $size/12))

	textoptions=("fontsize=$font:x=$xcor-text_w/2:y=$ycor")


framerate=($(ffprobe -v error -select_streams v:0 -show_entries stream=avg_frame_rate -of default=noprint_wrappers=1:nokey=1 "$1"))

#ffprobe -v error -select_streams v:0 -show_entries format_tags=timecode:stream_tags=timecode -of default=noprint_wrappers=1:nokey=1 B.mxf will print either/or. may be times where none exist.
tctest=($(ffprobe -v error -select_streams v:0 -show_entries format_tags=timecode:stream_tags=timecode -of default=noprint_wrappers=1:nokey=1 "$1")) 
tctest2=($(ffprobe -v error -select_streams v:0 -show_entries stream_tags=timecode -of default=noprint_wrappers=1:nokey=1 "$1"))
if [[ "${tctest}" == "" ]] ; then
	ffmpeg -i "$1" -c:v libx264 -crf 19 -pix_fmt yuv420p -vf drawtext="fontsize=45":"fontfile=/Library/Fonts/Arial\ Black.ttf:fontcolor=white:timecode='00\:00\:00\:00':rate=$framerate:boxcolor=0x000000AA:box=1:x=360-text_w/2:y=480" "$1_BITC.mov" ;exit
elif [[ "${tctest2}" == "" ]] ; then
	IFS=: read -a timecode < <(ffprobe -v error -show_entries format_tags=timecode -of default=noprint_wrappers=1:nokey=1 "$1")
else
	IFS=: read -a timecode < <(ffprobe -v error -show_entries stream_tags=timecode -of default=noprint_wrappers=1:nokey=1 "$1")

fi
		printf -v timecode "'%s\:%s\:%s\:%s'" "${timecode[@]}"
		echo "$timecode"

		drawtext_options=(
		    fontfile="/Library/Fonts/Arial Black.ttf"
		    fontcolor=white
		    timecode="$timecode"
		    rate="$framerate"
		    boxcolor=0x000000AA
		    box=1
			$textoptions
		    #x=360-text_w/2
		    #y=480
		)

		drawtext_options=$(IFS=:; echo "${drawtext_options[*]}")
		ffmpeg -i "$1" -c:v libx264 -crf 19 -pix_fmt yuv420p -vf \
		    drawtext="$drawtext_options" \
		    "${1}_BITC.mov"
		
		
else
		

echo "codec? Choose things like h264, prores etc"
read "codec";

container=("mov")

if [[ "${codec}" == "h264" || "${codec}" == "H264" ]] ; then
	videooptions=("-c:v h264 -pix_fmt yuv420p -crf 19")
elif [[ "${codec}" == "ffv1" || "${codec}" == "FFV1" ]] ; then
	videooptions=("-c:v ffv1 -level 3 -g 1")
else videooptions=("-c:v $codec")
fi

echo "Choose Mp3 or copy"
read "audio";


if [[ "${audio}" == "mp3" || "${audio}" == "MP3" ]] ; then
	audiooptions=("-c:a libmp3lame -qscale:a 2")

else audiooptions=("-c:a copy")
fi



echo "Any further alterations such as resizing or new container? Answer Y or N "
read "extra"
if [[ "${extra}" == "y" || "${extra}" == "Y" ]] ; then

echo "resize? Y or N"
read "resize";
if [[ "${resize}" == "y" || "${resize}" == "Y" ]] ; then
	echo "enter desired resolution in the following format - 720:576 OR 1024:576 OR 1920:1080"
	read "scale"
filteroptions+="-vf scale=$scale"
fi


echo "Container?"
read "container";

fi

ffmpeg -i "${1}" -map 0 ${videooptions} ${filteroptions} ${audiooptions} -dn "${1}_vimeo.${container}"

fi
