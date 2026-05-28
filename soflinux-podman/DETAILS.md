# Soldier Of Fortune NATIVE linux patch for connecting to latest protocol

## Contents
1. [Motivation](https://github.com/d3nd3/soflinux/blob/main/README.md#motivation)
3. [Obtaining](https://github.com/d3nd3/soflinux/blob/main/README.md#obtaining)
4. [Running](https://github.com/d3nd3/soflinux/blob/main/README.md#running)
    1. [dependencies](https://github.com/d3nd3/soflinux/blob/main/README.md#dependencies)
    1. [sound crash fix](https://github.com/d3nd3/soflinux/blob/main/README.md#sof-crashes-when-it-tries-to-play-audio)
    1. [scripts](https://github.com/d3nd3/soflinux/blob/main/README.md#place-launch_mpsh-launch_spsh-patchitsh-scripts-into-sof-directory)
    2. [launch](https://github.com/d3nd3/soflinux/blob/main/README.md#how-do-i-run-the-game)
    3. [doesnt work](https://github.com/d3nd3/soflinux/blob/main/README.md#what-if-it-doesnt-run)
    4. [experimental_server](https://github.com/d3nd3/soflinux/blob/main/README.md#server-mode-patch)
6. [Details](https://github.com/d3nd3/soflinux/blob/main/README.md#running)
    1. [solution](https://github.com/d3nd3/soflinux/blob/main/README.md#the-current-solution)
    1. [obstacles](https://github.com/d3nd3/soflinux/blob/main/README.md#obstacles)
    1. [tips](https://github.com/d3nd3/soflinux/blob/main/README.md#what-helped-me)
    1. [audio](https://github.com/d3nd3/soflinux/blob/main/README.md#lets-talk-about-audio)
    1. [won authentication](https://github.com/d3nd3/soflinux/blob/main/README.md#bypassing-won-lockdown-and-version-incompatibilities)
    2. [experiment_server](https://github.com/d3nd3/soflinux/blob/main/README.md#experimental-server-support)
 1. [Credits](https://github.com/d3nd3/soflinux/blob/main/README.md#credits)

## Motivation
Currently the sof linux version `1.06a` does not allow you to join servers that are not equal to it.  I love the idea of running SoF on linux without using wine because it makes the installation process more straightforward.
## Obtaining
### Where can i get SoF linux version?
[github.com/liflg](https://github.com/liflg/sof_1.06a-english_x86/tree/master/data)

`mkdir ~/sof1`

`tar -xvf patch-1.06a.tar -C ~/sof1`

If you know about the SoF Community Edition, you can use extra paks from there. (pak0,pak1,pak2,pak3)
## Running
### Dependencies

`sudo apt update`

`sudo apt install libgl1-mesa-glx libx11-6 libxext6`

### Sof crashes when it tries to play audio
Place [libXdmcp.so.6](https://github.com/d3nd3/soflinux/blob/main/libXdmcp.so.6) into your sof directory
### Place launch_mp.sh launch_sp.sh patchit.sh scripts into sof directory.
[launch_mp.sh](https://github.com/d3nd3/soflinux/blob/main/launch_mp.sh)

[launch_sp.sh](https://github.com/d3nd3/soflinux/blob/main/launch_sp.sh)

[patchit.sh](https://github.com/d3nd3/soflinux/blob/main/patchit.sh)

`chmod +x patchit.sh launch_mp.sh launch_sp.sh`

`./patchit.sh`

It will copy the sof binary and patch it so that you have a version to interact with windows community.
### How do i run the game?
You have 2 options:
* `./launch_mp.sh` - for connecting to windows 1.07f servers
* `./launch_sp.sh` - for normal 1.06a linux behavior ( you're stuck to localhost unfortunately )
### What if it doesn't run?
* Try changing the gl_driver line in launch script to `/usr/lib/i386-linux-gnu/mesa/libGL.so.1` instead.
### Server Mode Patch
[patchit_server.sh](https://github.com/d3nd3/soflinux/blob/main/patchit_server.sh)

`chmod +x patchit_server.sh`

`./patchit_server.sh`
## Details
### The Current Solution
* Tested on debian 9+ /w libc 2.23+.  Need more data samples to figure when it breaks.
* Ensure `ALSA OSS Kernel Modules` are loaded and compiled into your systems' kernel. Check your kernel config file @ `grep CONFIG_SND_PCM_OSS /boot/config-$(uname -r)`
* You can load it with `modprobe snd-pcm-oss` and `modprobe snd-mixer-oss`
* You'll require `libXdmcp.so.6` from ubuntu xenial 2.23 glibc.  This fixes a dreaded crash when audio starts to play. Just pop it in your directory.
* Uninstall `libtxc-dxtn0` because it seg faults.  If you really need s3 texture compression search around for a compatible version.
* `MESA_EXTENSION_MAX_YEAR=2000` is able to supress exposing too many GL EXTENSIONS thus overflowing some buffers in places.
* Launch option used to start the game:
  * `LD_LIBRARY_PATH=.` - the current directory needs to be put into the loader search path, for obvious reasons
  * `+set gl_driver /usr/lib/i386-linux-gnu/libGL.so.1` - use /usr/lib/i386-linux-gnu/mesa/libGL.so.1 for some distro like ubuntu.
  * `+set console 1` - who dosen't want console access?
  * `+set menu_key xxxx-xxxx-xxxx-xxxx-xxxx` - save you having to type enter your key when you reinstall. (There are some public keys online)
  * `+set vid_fullscreen 0` - useful for developing not wanting the resolution to change.
  * `+set gl_finish 1` - removes extreme flicker bug, unplayable without.
  * `+set version 1.07fx86F` - lets fake windows version , why not?
  * `+set protocol 33` - same
  * `+set no_won 1` - Disable WON authentication. Its required because WON is offline now. Dont worry, its not *really* lan only mode.
  * `+set developer 7` - Do you like more verbosity?
### Obstacles
During the journey of attempting to run SoF linux version on recent kernels/debian/ubuntu, I ran into many problems.
* Audio not working
* Game seg faulting on startup
* Being unable to authenticate with WON
### What helped me
Despite the many obstacles, I learnt a lot about debugging problems on linux.
* `LD_DEBUG=bindings` Since the linker in linux is often using lazy loading, everytime a function is ran for the first time, its symbol is looked up into linker thus revealing execution flow, great for debugging.
* `gdb --args` Running gdb is a huge help.
  * Remember to use `layout asm`
  * `break *0xDEADB33F`
  * `finish` to run until return from current function
* `IDA` Excellent tool
* `ldd --version ldd`
### Lets talk about Audio
The linux version of SoF is using Direct Memory Mapped Audio via OSS layer.  The `liboasnd.so` library interacts with `libopenal-0.0.so`, to prepare the device for receiving audio, buffer size and fragments etc must be set correctly.  The system API `fcntl` and `ioctl` are used for doing this but unfortately the recent linux glibc versions alter the behavior of `fcntl`, so if left untouched, sound will **not** work.

Yet sound works with OSS kernel emulation, why? Because ALSA automaticly sets those parameters on a lower layer.
**echo "binaryname 0 0 direct" > /proc/asound/card0/pcm0p/oss** is mentioned as a solution on the web for some games where the automatic setting of the parameters hurts the game instead.  This is not the case here, and without the automatic setting of the fragment/buffer parameters audio would not function.

*Quote from kernel.org*
> As default, ALSA emulates the OSS PCM with so-called plugin layer, i.e. tries to convert the sample format, rate or channels automatically when the card doesn’t support it > 
> natively. This will lead to some problems for some applications like quake or wine, especially if they use the card only in the MMAP mode.

So after you've ensured that the snd-pcm-oss module is loaded, you should be good to go.

### Bypassing won lockdown and version incompatibilities
To cut it short: the game wants you to check certificates from server.  But it can be altered as to skip this and use normal q2 style handshake. These are the 4 xxd patches you must make to your sof binary.
Always make a backup of the orignal sof-bin so that you can enjoy singleplayer bug free on 1.06a, copy it and patch it for for multiplayer interaction with windows clients and servers.
* Skips cert checking

`echo 90909090909090bf05000000 | xxd -r -p -seek 0x7e2cc - sof-bin`
* Use old challenge handler style

`echo 909090909090909090909090 | xxd -r -p -seek 0x7e2f4 - sof-bin`
* Protocol 33 instead of protocol 32 in ParseServerData

`echo "21" | xxd -r -p -seek 0x81ab0 - sof-bin`
* Remind server you are using protocol 33 not 32

`echo "21" | xxd -r -p -seek 0x7ce4b - sof-bin`
### Experimental server support
* sv_new_f

`echo "21" | xxd -r -p -seek 0x6831a - sof-bin`

* correct argv pointer

`echo 05 | xxd -r -p -seek 0x6249d - sof-bin`

* correct argv pointer

`echo 04 | xxd -r -p -seek 0x6246c - sof-bin`

* ignore connmode check

`echo 75 | xxd -r -p -seek 0x626b7 - sof-bin`

* ignore arg4

`echo 909090909090 | xxd -r -p -seek 0x626a9 - sof-bin`
## Credits
* Thanks to liflg for supplying a pre-patched 1.06a version.
* Thanks to Activision and Raven for making one of the best games to ever exist.
* Thanks to CheaterSkeeter, Acadie, Chin for sustaining interest in the game, despite its low player count.
* Thanks to [lutris/asgard](https://github.com/lutris/asgard/) for inspiring me that sof will run on modern distros.
* Thanks to GaLLo for teaching me the ropes and introducing me to linux initially.

