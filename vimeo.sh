#!/bin/bash -x

echo "codec? Choose things like h264, prores etc"
read "codec";

container=("mov")

if [[ "${codec}" == "h264" || "${codec}" == "H264" ]] ; then
	videooptions=("-c:v h264 -pix_fmt yuv420p")
elif [[ "${codec}" == "ffv1" || "${codec}" == "FFV1" ]] ; then
	videooptions=("-c:v ffv1 -level 3 -g 1")
else videooptions=("-c:v $codec")
fi

echo "Choose Mp3 or copy"
read "audio";


if [[ "${audio}" == "mp3" || "${audio}" == "MP3" ]] ; then
	audiooptions=("-c:a libmp3lame -qscale:a 2")

else audiooptions=("-c:v copy")
fi



echo "Any further alterations such as resizing or new container? Answer Y or N "
read "extra"
if [[ "${extra}" == "y" || "${extra}" == "Y" ]] ; then

echo "resize?"
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

