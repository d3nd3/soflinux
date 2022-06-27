#!/bin/bash
cp sof-bin sof-mp
# protocol 33
echo "21" | xxd -r -p -seek 0x7ce4b - sof-mp
# protocol @ ParseServerData
echo "21" | xxd -r -p -seek 0x81ab0 - sof-mp

# disable cert authentication
echo 90909090909090bf05000000 | xxd -r -p -seek 0x7e2cc - sof-mp
# challenger handler old style
echo 909090909090909090909090 | xxd -r -p -seek 0x7e2f4 - sof-mp

