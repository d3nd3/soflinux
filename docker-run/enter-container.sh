#!/bin/bash
# This file launches a login session into the container


NO_MOUNT="1"
# Set NOMOUNT if you want to NOT mount
if [ ! -z $NO_MOUNT ]; then
  echo "NO_MOUNT active: user and base are not mounted into container."
  NO_MOUNT=""
else
  NO_MOUNT="-v $DIR_USER:/home/mullins/.loki/sof --user $(id -u):$(id -g) \
  -v $DIR_BASEDIR:/home/mullins/.loki/sof-addons/base --user $(id -u):$(id -g)"
fi

. $(dirname "${BASH_SOURCE[0]}")/pre-run.sh
LAUNCH_OPTS="/bin/bash"

$TOSUDO docker run -it \
--platform linux/i386 \
--env DISPLAY=$DISPLAY \
--device /dev/dri \
$USE_PRIV \
$USE_VSYNC \
$DEVDSP \
$WSL_ENVIRONMENT \
-v /tmp/.X11-unix:/tmp/.X11-unix \
$NO_MOUNT \
--net=host \
--group-add audio \
$HOSTPORT \
--rm \
sof-linux /bin/bash $@
