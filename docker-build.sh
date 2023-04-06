#!/bin/bash

# ~/.loki/sof-addons/ is used to allow user to control autoexec.cfg and extra .pak files
# files downloaded from remote sof servers whilst inside the game are saved in the ~/.loki/sof directory.
# this is traditionally known as USER dir in sof windows.

if [ ! -d "docker-context" ];then
  echo "Run this script from the soflinux folder"
  exit 1
fi

# --build-arg RUN_DOCKER_CLIENT=1
# --build-arg MANUAL_CE=1
docker build -t sof-linux docker-context $@
if ! [ $? -eq 0 ]; then
	echo "failed build"
	exit 1
fi
# Check exit status of docker build command

echo "STANDBY: Copying demo and 1.06a pak to ~/.loki/sof-addons/ ..."

# Ensuse directories exist.
. docker-run/ensure-dirs.sh

docker create --name temp-sof-linux sof-linux > /dev/null 2>&1
# extract these 2 pak files from the install because its bind mounted
docker cp temp-sof-linux:/home/mullins/.loki/sof-addons/base/liflg_pak2.pak ~/.loki/sof-addons/base/
docker cp temp-sof-linux:/home/mullins/.loki/sof-addons/base/demo_pak0.pak ~/.loki/sof-addons/base/
docker rm temp-sof-linux > /dev/null 2>&1

cp docker-context/won_key ~/.loki/sof/
cp docker-context/default_video.cfg ~/.loki/sof/

# fix default drivers search not including libGL.so.1
mkdir -p ${USER_DIR}/drivers
echo -e "opengl\nopengl32\n3dfxvgl\n3dfxogl\nlibGL.so.1" > ~/.loki/sof/drivers/drivers.txt

echo "Image built - consider pruning your images to save disk-space."


