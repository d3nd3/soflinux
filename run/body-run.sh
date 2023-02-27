#!/bin/bash

# ----HOST FOLDERS MOUNTED INTO CONTAINER----
#/tmp/.X11-unix
#.loki/sof-addons/base [$BASEDIR/base]
#.loki/sof [$USER]
#/mnt/wslg

if [ ! -z $USE_PRIV ]; then
  echo "\n--privileged = TRUE.\n"
  USE_PRIV='--privileged'
fi

# 0 - Never synchronize with vertical refresh, ignore application's choice
# 1 - Initial swap interval 0, obey application's choice
# 2 - Initial swap interval 1, obey application's choice
# 3 - Always synchronize with vertical refresh, application chooses the minimum swap interval
if [ ! -z $VSYNC ]; then
  echo "VSYNC = TRUE"
  USE_VSYNC="-e vblank_mode=3"
else
  USE_VSYNC="-e vblank_mode=0"
fi

# Set NOMOUNT if you want to NOT mount
if [ ! -z $NO_MOUNT ]; then
  echo "NO_MOUNT active: user and base are not mounted into container."
  NO_MOUNT=""
else
  NO_MOUNT="-v $DIR_USER:/home/mullins/.loki/sof --user $(id -u):$(id -g) \
  -v $DIR_BASEDIR:/home/mullins/.loki/sof-addons/base --user $(id -u):$(id -g)"
fi
# Detect wslg environment
if [ -d /mnt/wslg ]; then
  echo "WSL_ENVIRONMENT = TRUE"
  WSL_ENVIRONMENT="-v /mnt/wslg/:/mnt/wslg/"
  WSL_AUDIO="pactl load-module module-tunnel-sink-new server=unix:$PULSE_SERVER sink_name=wslg;"
fi

# WSL doesn't depend on these in host
if [ -z "$WSL_ENVIRONMENT" ]; then
  if [ -e /dev/snd ]; then
    DEVSND='--device /dev/snd'
  else
    echo "Warning: /dev/snd not found, likely you'll have no sound."
  fi
  if [ -e /dev/dsp ]; then
    DEVDSP='--device /dev/dsp'
  else
    echo "Warning: /dev/dsp not found, osspd installed?"
  fi
  DISABLE_PULSE="systemctl --user stop pulseaudio.socket > /dev/null 2>&1;systemctl --user stop pulseaudio.service > /dev/null 2>&1;"'kill -9 $(pidof pulseaudio) > /dev/null 2>&1;'
fi

if [[ ! (`groups $USER` == *"docker"*) ]]; then
  echo "Using sudo, becuase your user is not in docker group."
  TOSUDO=sudo
else
  echo "Your user is in docker group, not using sudo."
fi

# WSL_ENVIRONMENT MODE WILL ROUTE AUDIO FROM CONTAINER DIRECTLY TO WSLG PULSEAUDIO SERVER
# USING UNIX SOCKETS IN /MNT/WSLG/
# TRYING TO MAKE CONTAINER'S PULSEAUDIO USE PASSTHROUGH BECAUSE LATENCY IS TOO HIGH ATM.

#$DEVSND \
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
sof-linux /bin/bash -c "$WSL_AUDIO $DISABLE_PULSE padsp $LAUNCH_OPTS $*"
# in bash $@ means preserve quotes of input
# $* means every space character encountered becomes a new argument, thus ignores quotes

