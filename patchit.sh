#!/bin/bash
cp sof-bin sof-mp
echo "21" | xxd -r -p -seek 0x7ce4b - sof-mp
echo "21" | xxd -r -p -seek 0x81ab0 - sof-mp
echo 90909090909090bf05000000 | xxd -r -p -seek 0x7e2cc - sof-mp
echo 909090909090909090909090 | xxd -r -p -seek 0x7e2f4 - sof-mp

