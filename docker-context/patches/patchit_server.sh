#!/bin/bash
cp sof-bin sof-mp-server
# 8048000 + rel = absolute

# SVC_DirectConnect - server has received `connect` packet from client
# Do not be Strict about argV return length
# 80AA3DE
echo "21" | xxd -r -p -seek 0x623de - sof-mp-server

#SVC_Info_f - server sends `info` packet to client
# Do not be Strict about argV return length
# 80A99D7
echo "21" | xxd -r -p -seek 0x619d7 - sof-mp-server


# SV_New_f Protocol changed from `32` to `33`
# 80B031A
echo "21" | xxd -r -p -seek 0x6831a - sof-mp-server

# correct argv pointer - SVC_DirectConnect adjusts the 6th parameter to be the same as the 5th
# 80AA49D
echo "05" | xxd -r -p -seek 0x6249d - sof-mp-server

# correct argv pointer - SVC_DirectConnect adjusts the 5th parameter to be the same as the 4th
# 80AA46C
echo "04" | xxd -r -p -seek 0x6246c - sof-mp-server

# ignore connmode check - SVC_DirectConnect , some authorization check
# 80AA6B7
echo "75" | xxd -r -p -seek 0x626b7 - sof-mp-server

# ignore arg4
# 80AA6A9 - SVC_DirectConnect arg4 , svs_ptr ?
echo "909090909090" | xxd -r -p -seek 0x626a9 - sof-mp-server
