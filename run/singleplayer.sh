#!/bin/bash



. $(dirname "${BASH_SOURCE[0]}")/pre-run.sh

LAUNCH_OPTS="\
./sof-bin \
+set basedir /home/mullins/.loki/sof-addons \
+set cddir static_files \
+set console 1 \
"
. $(dirname "${BASH_SOURCE[0]}")/body-run.sh

