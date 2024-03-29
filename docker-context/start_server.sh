#!/bin/bash

cd "$(dirname "$0")"
# echo "Current working directory is: $(pwd)"

LAUNCH_OPTS="\
+set dedicated 1 \
+set basedir $HOME/.loki/sof-addons \
+set cddir static_files \
+set console 1 \
+set version 1.07fX86F \
+set protocol 33
"
#LD_PRELOAD="libstdc++.so.6" LD_LIBRARY_PATH=. gdb --args ./sof-mp-server $LAUNCH_OPTS
vblank_mode=0 LD_PRELOAD="libstdc++.so.6" LD_LIBRARY_PATH=. ./sof-mp-server $LAUNCH_OPTS