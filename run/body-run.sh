#!/bin/bash

# ----HOST FOLDERS MOUNTED INTO CONTAINER----
#/tmp/.X11-unix
#.loki/sof-addons/base [$BASEDIR/base]
#.loki/sof [$USER]
$TOSUDO docker run -it \
--env DISPLAY=$DISPLAY \
--device /dev/dri \
$DEVSND \
$DEVDSP \
$USE_PRIV \
-v /tmp/.X11-unix:/tmp/.X11-unix \
-v ~/.loki/sof:/home/mullins/.loki/sof --user $(id -u):$(id -g) \
-v ~/.loki/sof-addons/base:/home/mullins/.loki/sof-addons/base --user $(id -u):$(id -g) \
--net=host \
--group-add audio \
$HOSTPORT \
sof-linux $LAUNCH_OPTS $@
# in bash $@ means preserve quotes of input
# $* means every space character encountered becomes a new argument, thus ignores quotes