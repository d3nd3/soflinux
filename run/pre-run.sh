#!/bin/bash

# This file ensures required folders exist and have correct permissions.
# Necessary for fixing sound and default gamma.
# And other options
# base folder on host, so that extra maps can be added
# user folder also on host, so that saves and downloads are persistent
# OPTIONS: USE_PRIV, NO_MOUNT 

USE_PRIV=""

# ensure directory exists
. $(dirname "${BASH_SOURCE[0]}")/ensure_dirs.sh

if [ ! -f ~/.loki/sof/default_video.cfg ]; then
  echo "Copying default_video.cfg fix into user dir..."
  cp ctx/default_video.cfg ~/.loki/sof/
  cp ctx/won_key ~/.loki/sof/
fi








