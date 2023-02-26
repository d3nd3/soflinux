#!/bin/bash

. ./pre-run.sh

LAUNCH_OPTS="\
./sof-bin \
+set basedir /home/mullins/.loki/sof-addons \
+set cddir static_files \
+set console 1 \
"
. ./body-run.sh

