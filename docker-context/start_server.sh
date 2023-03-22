#!/bin/bash

cd "$(dirname "$0")"
# echo "Current working directory is: $(pwd)"

LAUNCH_OPTS="\
+set dedicated 1 \
+set basedir /home/mullins/.loki/sof-addons \
+set cddir static_files \
+set console 1 \
+set version 1.07fX86F \
+set protocol 33
"
#LD_PRELOAD="libstdc++.so.6" LD_LIBRARY_PATH=. gdb --args ./sof-mp-server $LAUNCH_OPTS
LD_PRELOAD="libstdc++.so.6" LD_LIBRARY_PATH=. ./sof-mp-server $LAUNCH_OPTS