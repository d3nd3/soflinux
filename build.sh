#!/bin/bash

# ~/.loki/sof-addons/ is used to allow user to control autoexec.cfg and extra .pak files
# files downloaded from remote sof servers whilst inside the game are saved in the ~/.loki/sof directory.
# this is traditionally known as USER dir in sof windows.

if [ ! -d "ctx" ];then
  echo "Run this script from the soflinux folder"
  exit 1
fi
CONTAINER_ID=$(docker build -t sof-linux ctx | tail -n1 | awk '{print $NF}')
if docker inspect "$CONTAINER_ID" >/dev/null 2>&1; then
  echo "STANDBY: Copying demo and 1.06a pak to ~/.loki/sof-addons/ ..."
  docker cp $CONTAINER_ID:/home/mullins/.loki/sof-addons/* ~/.loki/sof-addons/
else
  echo "ERROR: Container not found."
fi

