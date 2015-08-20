#!/bin/bash

: '
Record and pull video
* Install FFMPEG first, ex: https://trac.ffmpeg.org/wiki/CompilationGuide/MacOSX
Via Homebrew is advised
* Before first start, get the rights to run it: chmod +x robogif.sh

Heavily inspired from:
* https://medium.com/sebs-top-tips/tip-create-gifs-of-your-apps-1bd76859dc3a
* https://gist.github.com/lorenzos/e8a97c1992cddf9c1142
'

# Default values
TMP_MP4_SDCARD="/sdcard/tmp_android_recording.mp4"
TMP_MP4_LOCAL="$HOME/.tmp/tmp_android_recording.mp4"

DEFAULT_VIDEO_BITRATE_Mbps=4

DEFAULT_GIF_WIDTH_PIXEL=300
DEFAULT_GIF_FRAME_RATE=15

GIF_FILE_DESTINATION="./video_android.gif"

# Header message
function header {
cat << EOF

Android to GIF
==============
** Requires ffmpeg (https://www.ffmpeg.org/) **

EOF
}

function usage {

header

cat << EOF
usage: robogif.sh
	-b | --bitrate bitrate
	-w | --width width
	-h

Default values:
* Video bitrate in Mbps: $DEFAULT_VIDEO_BITRATE_Mbps
* GIF width in pixels: $DEFAULT_GIF_WIDTH_PIXEL
* GIF frame rate: $DEFAULT_GIF_FRAME_RATE

EOF
}

# Variables
bitrate_mbps=$DEFAULT_VIDEO_BITRATE_Mbps
gif_width_px=$DEFAULT_GIF_WIDTH_PIXEL
gif_frame_rate=$DEFAULT_GIF_FRAME_RATE

# Start
while [ "$1" != "" ]; do
    case $1 in
        -b | --bitrate )   		shift
                                bitrate_mbps=$1
                                ;;
        -w | --width )   		shift
        						gif_width_px=$1
        						;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

VIDEO_BITRATE=$bitrate_mbps*1000000


# Starts
header

printf "Starting recording, press CTRL+C when you're done...\n"

trap "printf '\nRecording stopped'" INT
adb shell screenrecord --verbose --bit-rate $VIDEO_BITRATE "$TMP_MP4_SDCARD"
video_recording_return_code=$?

trap - INT

if [ $video_recording_return_code -ne 0 ]; then
	cat << EOF

Something went wrong when while recording the video on the device.
Make sure an Android device is accessible via adb (adb devices).
Also, video recording on Android requires Lollipop.
EOF
	exit -1
fi

printf "\nDownloading output..."
sleep 5
adb pull "$TMP_MP4_SDCARD" "$TMP_MP4_LOCAL"

sleep 1
printf "\nRemoving the video from the SDCard..."
adb shell rm "$TMP_MP4_SDCARD"

# Create frames
printf "\nConverting to GIF..."

ffmpeg -i "$TMP_MP4_LOCAL" -vf \
       scale=$gif_width_px:-1,format=rgb8,format=rgb24 \
       -r $DEFAULT_GIF_FRAME_RATE \
	   "$GIF_FILE_DESTINATION"

rm $TMP_MP4_LOCAL

if [ $? -eq 0 ]; then
	printf "\nAll done! File video_android.gif in the current working directory\n"
else
    printf "\nErgh something went wrong during GIF conversion, have you installed ffmpeg? (https://www.ffmpeg.org/)\n"
fi
exit 0