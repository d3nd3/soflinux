#!/bin/bash

# This file ensures required folders exist and have correct permissions.
# Necessary for fixing sound and default gamma.

if [[ `groups $USER` == *"docker"* ]]; then
 DOCKERGROUPED=1
fi

if [ ! -d "ctx" ];then
  echo "Run this script from the soflinux folder"
  exit 1
fi

# User folder creation
if [ ! -d ~/.loki/sof ] ; then
  echo "Creating user directory at ~/.loki/sof..."
  #ensure mounted folders are created before-hand
  #so that permission is not unwriteable root.
  mkdir -p ~/.loki/sof
else
  if [ `stat --format '%U' ~/.loki/sof` = "root" ]; then
    echo "Your loki user directory is root-owned, this has to be changed"
    sudo chown -R $USER:$USER ~/.loki/sof
  fi
fi

# $basedir addons folder creation
if [ ! -d ~/.loki/sof-addons/base ] ; then
  echo "Creating base directory at ~/.loki/sof-addons..."
  echo "Use this for extra map .pak files and autoexec.cfg"
  mkdir -p ~/.loki/sof-addons/base
else
  if [ `stat --format '%U' ~/.loki/sof-addons/base` = "root" ]; then
    echo "Your loki base directory is root-owned, this has to be changed"
    sudo chown -R $USER:$USER ~/.loki/sof-addons/base
  fi
fi

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
  echo "Warning: /dev/snd not found, likely sound issues"
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