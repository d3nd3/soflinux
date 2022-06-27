#!/bin/bash
cp sof-bin sof-mp-server

#svc_DirectConnect protocol 33 no reject
echo "21" | xxd -r -p -seek 0x623de - sof-mp-server
#svc_info_f connectionless packet for server listing protocol 33
echo "21" | xxd -r -p -seek 0x619d7 - sof-mp-server

# protocol 33 sv_new_f
echo "21" | xxd -r -p -seek 0x6831a - sof-mp-server
# correct argv pointer
echo 05 | xxd -r -p -seek 0x6249d - sof-mp-server
# correct argv pointer
echo 04 | xxd -r -p -seek 0x6246c - sof-mp-server
# ignore connmode check
echo 75 | xxd -r -p -seek 0x626b7 - sof-mp-server
# ignore arg4
echo 909090909090 | xxd -r -p -seek 0x626a9 - sof-mp-server
