#!/bin/bash
# Attempts to build the docker container and extract the files to your local system.
USER_DIR=~/.loki/sof
INSTALL_DIR=~/.loki/sof-runtime
VERBOSE=""

for arg in "$@"; do
  if [[ "$arg" == "-v" ]]; then
    echo "Verbose: True"
    VERBOSE=1
    break
  fi
  if [[ "$arg" == '--build-arg'* ]]; then
    BUILD_ARGS="${BUILD_ARGS} ${arg}"
  fi
done

case ${1} in
  --dir)
    echo "--dir"
    if [[ ${2} != "" ]]; then
      echo "Installing to ${2}"
      echo "Is this correct. Do you want to proceed? (y/n)"
      read -n 1 confirm
      echo
      if [ "$confirm" = "y" ]; then
        INSTALL_DIR=${2}
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
    echo "--dir <installdir> - Where to install sof binaries. default:~/.loki/sof-runtime"
    echo "--v/-v = Verbose Mode - default: silent"
    exit 0
    ;;
  *)
    echo "Soldier of Fortune Linux Installer based on 1.06jLINUXF"
    echo
    echo "Installing to ${INSTALL_DIR}"
      echo "Is this correct. Do you want to proceed? (y/n)"
      read -n 1 confirm
      echo
      if [ "$confirm" = "y" ]; then
        echo "Ok."
      else
          echo "You did not confirm. Exiting..."
          exit 1
      fi
    ;;
esac

mkdir -p ${INSTALL_DIR}/static_files/base

echo "Performing Docker Build..."

# Build the image.
if [ -z ${VERBOSE} ]; then
  ./docker-build.sh ${BUILD_ARGS}  > /dev/null 2>&1

  echo "Building compatibile libbsd library..."
  docker build -t libbsd libbsd-context > /dev/null 2>&1
  docker create --name tmp-libbsd libbsd > /dev/null 2>&1
  docker cp tmp-libbsd:/libbsd/libbsd.so.0.2.0 ${INSTALL_DIR}/libbsd.so.0
  docker rm tmp-libbsd > /dev/null 2>&1
else
  ./docker-build.sh ${BUILD_ARGS}

  echo "Building comptabile libbsd library..."
  docker build -t libbsd libbsd-context
  docker create --name tmp-libbsd libbsd
  docker cp tmp-libbsd:/libbsd/libbsd.so.0.2.0 ${INSTALL_DIR}/libbsd.so.0
  docker rm tmp-libbsd
fi


# After docker is installed, must copy the 3 folders into system.
# docker-build already handles liflg_pak2.pak and demo_pak0.pak @ ~/.loki/sof-addons/base/*
# and folders are ensured to exist. ~/.loki/sof ~/.loki/sof-addons/base

echo "Installing..."
docker create --name temp-sof-linux sof-linux > /dev/null 2>&1

for FILE in libSDL-1.1.so.0 libTitan.so liboasnd.so libopenal-0.0.so ref_gl.so sof-bin sof-mp sof-mp-server
do
  docker cp temp-sof-linux:/home/mullins/sof/${FILE} ${INSTALL_DIR}/
done

for FILE in basicpack2015v2.pak gamex86.so player.so pak0.pak pak1.pak pak2.pak pak3.pak
do
  docker cp temp-sof-linux:/home/mullins/sof/static_files/base/${FILE} ${INSTALL_DIR}/static_files/base/
done

docker rm temp-sof-linux > /dev/null 2>&1

# Run scripts
cp docker-context/start_multiplayer.sh docker-context/start_server.sh docker-context/start_singleplayer.sh ${INSTALL_DIR}
chmod +x ${INSTALL_DIR}/start_singleplayer.sh ${INSTALL_DIR}/start_server.sh ${INSTALL_DIR}/start_multiplayer.sh


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




