#!/bin/bash

cd "$(dirname "$0")"

LAUNCH_OPTS="\
+set version 1.07fx86F \
+set protocol 33 \
+set basedir $HOME/.loki/sof-addons \
+set cddir static_files \
+set console 1
"
#LD_PRELOAD="libstdc++.so.6" LD_LIBRARY_PATH=. gdb --args ./sof-mp $LAUNCH_OPTS
LD_PRELOAD="libstdc++.so.6 libSDL-1.2.so.0 libSDL-1.1.so.0" LD_LIBRARY_PATH=. ./sof-mp $LAUNCH_OPTS