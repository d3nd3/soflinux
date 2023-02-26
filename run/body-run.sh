#!/bin/bash

# ----HOST FOLDERS MOUNTED INTO CONTAINER----
#/tmp/.X11-unix
#.loki/sof-addons/base [$BASEDIR/base]
#.loki/sof [$USER]

USERDIR=~/.loki/sof
ADDONDIR=~/.loki/sof-addons/base

WSLAUDIO=""
# Set WSLAUDIO if you are using WSL
if [ ! -z $WSLAUDIO ]; then
	echo "Using WSL audio"
	WSLAUDIO="-e PULSE_SERVER=${PULSE_SERVER} -v /mnt/wslg/:/mnt/wslg/"
fi

# Set NOMOUNT if you want to NOT mount
if [ ! -z $NOMOUNT ]; then
	echo "User dir not mounted"
	NOMOUNT=""
else
	NOMOUNT="-v $USERDIR:/home/mullins/.loki/sof --user $(id -u):$(id -g) \
	-v $ADDONDIR:/home/mullins/.loki/sof-addons/base --user $(id -u):$(id -g)"
fi
$TOSUDO docker run -it \
--env DISPLAY=$DISPLAY \
--device /dev/dri \
$DEVSND \
$DEVDSP \
$USE_PRIV \
$WSLAUDIO \
-v /tmp/.X11-unix:/tmp/.X11-unix \
$NOMOUNT \
--net=host \
--group-add audio \
$HOSTPORT \
sof-linux padsp $LAUNCH_OPTS $@
# in bash $@ means preserve quotes of input
# $* means every space character encountered becomes a new argument, thus ignores quotes

#-v /run/user/1000:/run/user/1000 \
#--device /dev/mixer \
#-e XDG_RUNTIME_DIR=/run/user/1000 \