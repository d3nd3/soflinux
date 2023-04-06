#!/bin/bash -e
INSTALL_DIR=~/.loki/sof-runtime

docker build -t libsdl libsdlcompat-context
docker create --name tmp-libsdl libsdl
docker cp -L tmp-libsdl:/sdl12-compat/libSDL-1.2.so.0 ${INSTALL_DIR}/libSDL-1.2.so.0
docker cp -L tmp-libsdl:/SDL/build/build/.libs/libSDL2-2.0.so.0 ${INSTALL_DIR}/libSDL2-2.0.so.0
docker rm tmp-libsdl