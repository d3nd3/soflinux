#!/bin/bash
# This file launches a login session into the container

. ./pre-run.bash

$TOSUDO docker run -it \
--privileged \
--device /dev/dri \
--device /dev/snd \
--env XDG_RUNTIME_DIR=/run/mullins/1000 \
--env DISPLAY=$DISPLAY \
-v /tmp/.X11-unix:/tmp/.X11-unix \
-v ~/.loki/sof-base:/home/mullins/sof/base \
-v ~/.loki/sof:/home/mullins/.loki/sof \
sof-linux /bin/bash
