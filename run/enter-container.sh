#!/bin/bash
# This file launches a login session into the container

. $(dirname "${BASH_SOURCE[0]}")/pre-run.sh
LAUNCH_OPTS="/bin/bash"

NOMOUNT=1
. $(dirname "${BASH_SOURCE[0]}")/body-run.sh
