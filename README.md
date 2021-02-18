# Soldier Of Fortune linux patch connect to windows

## The Current Solution
* Tested on debian 9+ /w libc 2.23+.  Need more data samples to figure when it breaks.
* Ensure `ALSA OSS Kernel Modules` are loaded and compiled into your systems' kernel. Check your kernel config file @ `grep CONFIG_SND_PCM_OSS /boot/config-$(uname-r)`
* You can load it with `modprobe snd-pcm-oss` and `modprobe snd-mixer-oss`
* You'll require `libXdmcp.so.6` from ubuntu xenial 2.23 glibc.  This fixes a dreaded crash when audio starts to play.
## Motivation
Currently the sof linux version `1.06a` does not allow you to join servers that are not equal to it.  I love the idea of running SoF on linux without using wine because it makes the installation process more straightforward.

## Obstacles
During the journey of attempting to run SoF linux version on recent kernels/debian/ubuntu, I ran into many problems.
* Audio not working
* Game seg faulting on startup
* Being unable to authenticate with WON

## What helped me
Despite the many obstacles, I learnt a lot about debugging problems on linux.
* `LD_DEBUG=bindings` Since the linker in linux is often using lazy loading, everytime a function is ran for the first time, its symbol is looked up into linker thus revealing execution flow, great for debugging.
* `gdb --args` Running gdb is a huge help.
  * Remember to use `layout asm`
  * `break *0xDEADB33F`
  * `finish` to run until return from current function
* `IDA` Excellent tool
* `ldd --version ldd`

## Lets talk about Audio
The linux version of SoF is using Direct Memory Mapped Audio via OSS layer.  The `liboasnd.so` library interacts with `libopenal-0.0.so`, to prepare the device for receiving audio, buffer size and fragments etc must be set correctly.  The system API `fcntl` and `ioctl` are used for doing this but unfortately the recent linux glibc versions alter the behavior of `fcntl`, so if left untouched, sound will **not** work.

Yet 
