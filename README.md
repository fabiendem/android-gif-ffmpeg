# Android video capture to GIF via ffmpeg, in one command!

Heavily inspired from:
* https://medium.com/sebs-top-tips/tip-create-gifs-of-your-apps-1bd76859dc3a
* https://gist.github.com/lorenzos/e8a97c1992cddf9c1142

## Prerequisites
* Your Android device MUST run on **Android 5.0 (Lollipop)**
* Your Android device MUST be connected via USB

## Setup

### Make sure adb is installed
```
whereis adb
```
If not please follow: http://developer.android.com/tools/help/adb.html

### Install ffmpeg
You need to install **FFMPEG first**  

#### MacOS
Please follow instructions at: https://trac.ffmpeg.org/wiki/CompilationGuide/MacOSX  
It's dead simple via homebrew:
```
brew install ffmpeg
```

### Grant execute rights on the script
Before first start, get the rights to run it: `chmod +x robotgif.sh`


## Usage

Simply run `./robotgif.sh`  
Your GIF will appear in the current working directory: `./video_android.gif`

### Specify parameters
Possible to use a combination of parameters

#### Video Input
* Bitrate for video capture (Mbps)
```
./robotgif.sh -bitrate 6
./robotgif.sh -b 6
```

#### GIF output
* GIF width in px
```
./robotgif.sh -width 400
./robotgif.sh -w 400
```

### Show help
```
./robotgif.sh -h
```
