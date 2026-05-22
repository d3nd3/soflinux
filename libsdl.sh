#!/bin/bash -e
INSTALL_DIR=~/.loki/sof-runtime

podman build -t libsdl libsdlcompat-context
podman create --name tmp-libsdl libsdl
podman cp -L tmp-libsdl:/sdl12-compat/libSDL-1.2.so.0 ${INSTALL_DIR}/libSDL-1.2.so.0
podman cp -L tmp-libsdl:/SDL/build/build/.libs/libSDL2-2.0.so.0 ${INSTALL_DIR}/libSDL2-2.0.so.0
podman rm tmp-libsdl
