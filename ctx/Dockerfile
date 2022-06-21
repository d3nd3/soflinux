#1.06
#git clone https://github.com/liflg/sof_1.06a-english_x86
#cd sof_1.06a-english_x86
#tar -xvf data/patch-1.06a.tar -C OUTPUTDIR

#demo loki iso?
#tar -xvzf sof_demo.tar.gz
#cp sof_demo/base/pak0.pak OUTPUTDIR/base

#now we have pak2.pak from v1.06a and pak0.pak from demo

#loki compat libraries? take note, they exist., asgard uses them. (has them)
#1.06a lifgl supplies an improved launch script, sof.sh. <- interesting

# sof1.org/download/Soldier_of_Fortune_Community_Edition_V6_2.exe

#vblank_mode=0 for unlocked fps.

# ubuntu Focal
# grab files to making a working sof directory
#Focal doesnt have nano
#Xenial has python 3.5, pip requires is broken because of f"" not supported on <3.6
#So Use bionic, = python 3.6
#sof_ce_installer.exe is build with Smart Install Maker
FROM i386/ubuntu:bionic AS builder
#echo "deb [trusted=yes] http://ppa.launchpad.net/deadsnakes/ppa ubuntu bionic main" >> /etc/apt/sources.list
RUN apt -y update && apt install -y git python3 python3-pip && pip3 install requests
RUN \ 
	mkdir /sof && \
	git clone https://github.com/liflg/sof_1.06a-english_x86 && \
	tar -xvf sof_1.06a-english_x86/data/patch-1.06a.tar -C /sof && \
	git clone https://github.com/d3nd3/soflinux && \
	tar -xvzf soflinux/sof_demo.tar.gz && \
	cp sof_demo/base/pak0.pak /sof/base/pak5.pak && \
	mv sof/base/pak2.pak sof/base/pak6.pak && \
	git clone https://github.com/d3nd3/sof-ce-dl && \
	python3 sof-ce-dl/get.py
# -------------------------------------------------------------

RUN apt -y install wine-stable xvfb
#RUN Xvfb :0 -nolisten tcp &
RUN xvfb-run wine sof_ce_installer.exe /s /l=English /p=./sof-ce
#RUN cp sof-ce/Base/basicpack2015v2.pak sof/base/ && \
#cp sof-ce/Base/pak*.pak sof/base/

#paks loaded
# Final
FROM i386/ubuntu:xenial
RUN apt-get -y update && apt-get -y install libgl1-mesa-glx libx11-6 libxext6 && \
rm -rf /var/lib/apt/lists/*


RUN adduser --disabled-password --gecos '' mullins
USER mullins
WORKDIR /home/mullins
RUN mkdir -p sof/base
COPY --from=builder --chown=mullins /sof-ce/Base/basicpack2015v2.pak sof/base/
COPY --from=builder --chown=mullins /sof-ce/Base/pak*.pak sof/base/
COPY --from=builder --chown=mullins /sof sof/

USER root
#RUN apt remove libtxc-dxtn0 && apt install libxdmcp6
USER mullins

#CMD ["bash"]
WORKDIR sof
SHELL ["/bin/bash" , "-c"]
RUN \
	echo -ne "won_set_key ben2-bac7-buz6-jad3-9742\n" \
	"vid_brightness 0.6\n" \
	"vid_contrast 0.6\n" \
	"vid_gamma 0\n" \
	"gl_modulate 1\n" \
	"vid_restart\n" \
	"cl_maxfps 150\n"  > base/autoexec.cfg
ENV MESA_EXTENSIONS_MAX_YEAR=2000
ENV vblank_mode=1
CMD ["./sof","+set console 1;+set developer 7"]
