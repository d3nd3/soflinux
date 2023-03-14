#!/bin/bash

cd "$(dirname "$0")"

LAUNCH_OPTS="\
+set basedir /home/mullins/.loki/sof-addons \
+set cddir static_files \
+set console 1
"
#LD_PRELOAD="libstdc++.so.6" LD_LIBRARY_PATH=. gdb --args ./sof-mp $LAUNCH_OPTS
LD_PRELOAD="libstdc++.so.6" LD_LIBRARY_PATH=. ./sof-bin $LAUNCH_OPTS