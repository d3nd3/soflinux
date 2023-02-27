#!/bin/bash

. $(dirname "${BASH_SOURCE[0]}")/pre-run.sh

LAUNCH_OPTS="\
./sof-mp \
+set version 1.07fx86F \
+set protocol 33 \
+set basedir /home/mullins/.loki/sof-addons \
+set cddir static_files \
+set console 1 \
"
. $(dirname "${BASH_SOURCE[0]}")/body-run.sh
