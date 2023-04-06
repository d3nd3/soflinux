#!/bin/bash

# set default values for directories
USER_DIR=${HOME}/.loki/sof
INSTALL_DIR=${HOME}/.loki/sof-runtime
SILENT=0

# parse command line arguments
for arg in "$@"; do
  case "$arg" in
	-s)
	  SILENT=1
	  echo "Silent: True"
	  ;;
	--build-arg*)
	  BUILD_ARGS="${BUILD_ARGS} ${arg}"
	  ;;
  esac
done
echo "Soldier of Fortune Linux Installer based on 1.06jLINUXF"
echo
# check the option and take action
case "$1" in
  --dir)
	echo "--dir"
	if [[ -n "$2" ]]; then
	  echo "Installing to $2"
	  read -p "Is this correct. Do you want to proceed? (y/n) " confirm
	  if [[ "$confirm" = [yY] ]]; then
		INSTALL_DIR="$2"
		echo "Proceeding..."
	  else
		echo "You did not confirm. Exiting..."
		exit 1
	  fi
	else
	  echo "error: Specify an install directory"
	  exit 1
	fi
	;;
  --help|-h)
	echo "Usage: installer.sh [OPTION]"
	echo "--help/-h = Help"
	echo "--dir <installdir> - Where to install sof binaries. default: ~/.loki/sof-runtime"
	echo "-s = Silent Mode - default: NotSilent"
	exit 0
	;;
	# DEFAULT_CASE
  *)
	
	echo "Installing to $INSTALL_DIR"
	read -p "Is this correct. Do you want to proceed? (y/n) " confirm
	if [[ "$confirm" = [yY] ]]; then
	  echo "Ok."
	else
		echo "You did not confirm. Exiting..."
		exit 1
	fi
	;;
esac

# make directories
mkdir -p "${INSTALL_DIR}/static_files/base"

echo "Performing Docker Build..."

# Build the image and copy required files to local system
if [ ${SILENT} -eq 1 ]; then

	./docker-build.sh ${BUILD_ARGS} > /dev/null 2>&1

	echo "Building compatible libbsd library..."

	docker build -t libbsd libbsd-context > /dev/null 2>&1
	if ! [ $? -eq 0 ]; then
		echo "failed build"
		exit 1
	endif

	docker create --name tmp-libbsd libbsd > /dev/null 2>&1
	if ! [ $? -eq 0 ]; then
		echo "failed build"
		exit 1
	endif

	docker cp tmp-libbsd:/libbsd/libbsd.so.0.2.0 "${INSTALL_DIR}/libbsd.so.0" > /dev/null 2>&1
	if ! [ $? -eq 0 ]; then
		echo "failed build"
		exit 1
	endif

	docker rm tmp-libbsd > /dev/null 2>&1
	if ! [ $? -eq 0 ]; then
		echo "failed build"
		exit 1
	endif
elif [ ${SILENT} -eq 0 ]; then
	./docker-build.sh ${BUILD_ARGS}
	echo "Building compatible libbsd library..."
	docker build -t libbsd libbsd-context
	docker create --name tmp-libbsd libbsd
	docker cp tmp-libbsd:/libbsd/libbsd.so.0.2.0 "${INSTALL_DIR}/libbsd.so.0"
	docker rm tmp-libbsd
fi

echo "Installing..."
# After docker is installed, must copy the 3 folders into system.
# docker-build already handles liflg_pak2.pak and demo_pak0.pak @ ~/.loki/sof-addons/base/*
# and folders are ensured to exist. ~/.loki/sof ~/.loki/sof-addons/base
if [ ${SILENT} -eq 0 ]; then
	# default not silent
	docker create --name temp-sof-linux sof-linux
	if ! [ $? -eq 0 ]; then
		echo "failed build"
		exit 1
	endif
	for FILE in libSDL-1.1.so.0 libTitan.so liboasnd.so libopenal-0.0.so ref_gl.so sof-bin sof-mp sof-mp-server
	do
		docker cp temp-sof-linux:/home/mullins/sof/${FILE} ${INSTALL_DIR}/\
		if ! [ $? -eq 0 ]; then
			echo "failed build"
			exit 1
		endif
	done
	for FILE in basicpack2015v2.pak gamex86.so player.so pak0.pak pak1.pak pak2.pak pak3.pak gs.pak
	do
		docker cp temp-sof-linux:/home/mullins/sof/static_files/base/${FILE} ${INSTALL_DIR}/static_files/base/
		if ! [ $? -eq 0 ]; then
			echo "failed build"
			exit 1
		endif
	done
	docker rm temp-sof-linux
	if ! [ $? -eq 0 ]; then
		echo "failed build"
		exit 1
	endif
	# Run scripts
	cp docker-context/start_multiplayer.sh docker-context/start_server.sh docker-context/start_singleplayer.sh ${INSTALL_DIR}
	chmod +x ${INSTALL_DIR}/start_singleplayer.sh ${INSTALL_DIR}/start_server.sh ${INSTALL_DIR}/start_multiplayer.sh
elif [ ${SILENT} -eq 1 ]; then
	# silent
	docker create --name temp-sof-linux sof-linux > /dev/null 2>&1
	if ! [ $? -eq 0 ]; then
		echo "failed build"
		exit 1
	endif
	for FILE in libSDL-1.1.so.0 libTitan.so liboasnd.so libopenal-0.0.so ref_gl.so sof-bin sof-mp sof-mp-server
	do
		docker cp temp-sof-linux:/home/mullins/sof/${FILE} ${INSTALL_DIR}/ > /dev/null 2>&1
		if ! [ $? -eq 0 ]; then
			echo "failed build"
			exit 1
		endif
	done
	for FILE in basicpack2015v2.pak gamex86.so player.so pak0.pak pak1.pak pak2.pak pak3.pak gs.pak
	do
		docker cp temp-sof-linux:/home/mullins/sof/static_files/base/${FILE} ${INSTALL_DIR}/static_files/base/ > /dev/null 2>&1
		if ! [ $? -eq 0 ]; then
			echo "failed build"
			exit 1
		endif
	done
	docker rm temp-sof-linux > /dev/null 2>&1
	if ! [ $? -eq 0 ]; then
		echo "failed build"
		exit 1
	endif
	# Run scripts
	cp docker-context/start_multiplayer.sh docker-context/start_server.sh docker-context/start_singleplayer.sh ${INSTALL_DIR} > /dev/null 2>&1
	chmod +x ${INSTALL_DIR}/start_singleplayer.sh ${INSTALL_DIR}/start_server.sh ${INSTALL_DIR}/start_multiplayer.sh > /dev/null 2>&1
fi

echo "Installed."
echo
echo "soflinux is installed to ${INSTALL_DIR}"
echo
echo "game paks are installed to  ${INSTALL_DIR}/static_files/base"
echo
echo "user dir is ${USER_DIR} - content downloaded from in-game are saved here"
echo
echo "addons dir is "${USER_DIR}-addons/base" - place extra resources here"
echo
echo "to launch sof single player - run ~/.loki/sof-runtime/start_singleplayer.sh"
echo 
echo "to launch sof multi player 1.07f - run ~/.loki/sof-runtime/start_multiplayer.sh"
echo 
echo "to launch a dedicated sof server 1.07f - run ~/.loki/sof-runtime/start_server.sh"
echo
echo "recommended aliases to put into ~/.bash_aliases"
echo 'alias sof-sp="~/.loki/sof-runtime/start_singleplayer.sh"
alias sof-mp="~/.loki/sof-runtime/start_multiplayer.sh"
alias sof-mp-s="~/.loki/sof-runtime/start_server.sh"'




