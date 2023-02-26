#!/bin/bash

. ./pre-run.sh

LAUNCH_OPTS="\
./sof-mp-server \
+set dedicated 1 \
+set basedir /home/mullins/.loki/sof-addons \
+set cddir static_files \
+set console 1 \
+set version 1.07fX86F \
+set protocol 33 \
"

HOSTPORT=28910
if [ ! -z HOSTPORT ]; then
  HOSTPORT="-p $HOSTPORT:$HOSTPORT/udp"
else
  # default to 28910
  HOSTPORT='-p 28910:28910/udp'
fi

. ./body-run.sh