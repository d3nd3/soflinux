#!/bin/bash

# ~/.loki/sof-addons/ is used to allow user to control autoexec.cfg and extra .pak files
# files downloaded from remote sof servers whilst inside the game are saved in the ~/.loki/sof directory.
# this is traditionally known as USER dir in sof windows.

if [ ! -d "ctx" ];then
  echo "Run this script from the soflinux folder"
  exit 1
fi

# Ensuse directories exist.
. run/ensure_dirs.sh

CONTAINER_ID=$(docker build -t sof-linux ctx 2>&1 | tee /dev/tty | grep -oP '(?<=Successfully built )\w+' | tail -1)

if docker inspect "$CONTAINER_ID" >/dev/null 2>&1; then
  echo "STANDBY: Copying demo and 1.06a pak to ~/.loki/sof-addons/ ..."

  docker create --name temp-sof-linux sof-linux > /dev/null 2>&1
  docker cp temp-sof-linux:/home/mullins/.loki/sof-addons/base/liflg_pak2.pak ~/.loki/sof-addons/base/
  docker cp temp-sof-linux:/home/mullins/.loki/sof-addons/base/demo_pak0.pak ~/.loki/sof-addons/base/
  docker rm temp-sof-linux > /dev/null 2>&1

  cp ctx/won_key ~/.loki/sof/
  cp ctx/default_video.cfg ~/.loki/sof/

  echo "Image built - consider pruning your images to save disk-space."
else
  echo "ERROR: Container not found."
fi

