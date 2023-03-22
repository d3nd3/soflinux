#!/bin/bash
cp sof-bin sof-mp
# 8048000 + rel = absolute

# no_won could had been set to 1
# but seemed more hassle to deal with that method.

# CL_HandleChallenge - change protocol from 32 to protocol 33
# 80C4E4B
echo "21" | xxd -r -p -seek 0x7ce4b - sof-mp

# CL_ParseServerData - change protocol from 32 to protocol 33
# 80C9AB0
echo "21" | xxd -r -p -seek 0x81ab0 - sof-mp

# CL_ConnectionlessPacket - disable cert authentication - don't act upon 3rd Argument.
# 80C62CC
echo "90909090909090bf05000000" | xxd -r -p -seek 0x7e2cc - sof-mp

# CL_ConnectionlessPacket - challenger handler old style - don't act upon 2nd Argument.
# 80C62F4
echo "909090909090909090909090" | xxd -r -p -seek 0x7e2f4 - sof-mp

