#!/bin/bash
cp sof-bin sof-mp-server
echo "21" | xxd -r -p -seek 0x6831a - sof-mp-server
echo 05 | xxd -r -p -seek 0x6249d - sof-mp-server
echo 04 | xxd -r -p -seek 0x6246c - sof-mp-server
echo 75 | xxd -r -p -seek 0x626b7 - sof-mp-server
echo 909090909090 | xxd -r -p -seek 0x626a9 - sof-mp-server
