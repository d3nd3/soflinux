#!/bin/bash

# This file ensures required folders exist and have correct permissions.
# Necessary for fixing sound and default gamma.

if [[ `groups $USER` == *"docker"* ]]; then
 DOCKERGROUPED=1
fi

# ensure directory exists
. $(dirname "${BASH_SOURCE[0]}")/ensure_dirs.sh

if [ ! -f ~/.loki/sof/default_video.cfg ]; then
  echo "Copying default_video.cfg fix into user dir..."
  cp ctx/default_video.cfg ~/.loki/sof/
  cp ctx/won_key ~/.loki/sof/
fi
# base folder on host, so that extra maps can be added
# user folder also on host, so that saves and downloads are persistent
if [ -z $DOCKERGROUPED ]; then
  echo "Using sudo, becuase your user is not in docker group"
  TOSUDO=sudo
fi
if [ -e /dev/snd ]; then
  DEVSND='--device /dev/snd'
else
  echo "Warning: /dev/snd not found, likely sound issues unless you are on a specificly configured system like wsl"
fi
if [ -e /dev/dsp ]; then
  DEVDSP='--device /dev/dsp'
else
  echo "Warning: /dev/dsp not found, osspd installed?"
fi

if [ ! -z $USE_PRIV ]; then
  echo "Using privileged mode"
  USE_PRIV='--privileged'
fi