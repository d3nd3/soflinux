#!/bin/bash

echo "IMPORTANT: edit docker-build.sh and ensure RUN_DOCKER_CLIENT is set when building, eg. : --build-arg RUN_DOCKER_CLIENT=1 else mesa(graphics) and osspd(sound) is not installed."

. $(dirname "${BASH_SOURCE[0]}")/pre-run.sh

LAUNCH_OPTS="\
./sof-bin \
+set basedir /home/mullins/.loki/sof-addons \
+set cddir static_files \
+set console 1 \
"
. $(dirname "${BASH_SOURCE[0]}")/body-run.sh

