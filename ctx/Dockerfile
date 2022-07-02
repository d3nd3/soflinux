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


#---------------------------------------------
# get all resources into one directory
#---------------------------------------------
FROM i386/ubuntu:bionic AS builder
#echo "deb [trusted=yes] http://ppa.launchpad.net/deadsnakes/ppa ubuntu bionic main" >> /etc/apt/sources.list
RUN apt -y update && apt install -y git python3 python3-pip && pip3 install requests
# get 1.06a
RUN \ 
	mkdir /sof && \
	git clone https://github.com/liflg/sof_1.06a-english_x86 && \
	tar -xvf sof_1.06a-english_x86/data/patch-1.06a.tar -C /sof && \
	mv sof/base/pak2.pak sof/base/pak6.pak && \
	git clone https://github.com/d3nd3/sof-ce-dl && \
	python3 sof-ce-dl/get.py
# -------------------------------------------------------------

#extract SoF-CE
RUN apt -y install wine-stable xvfb
#RUN Xvfb :0 -nolisten tcp &
RUN xvfb-run wine sof_ce_installer.exe /s /l=English /p=./sof-ce
#RUN cp sof-ce/Base/basicpack2015v2.pak sof/base/ && \
#cp sof-ce/Base/pak*.pak sof/base/

#fetch soflinux github repo
#extract demo
#apply v1.07 compat patch
RUN apt-get -y install xxd && \
git clone https://github.com/d3nd3/soflinux && \
tar -xvzf soflinux/sof_demo.tar.gz && \
cp sof_demo/base/pak0.pak /sof/base/pak5.pak && \
cp soflinux/patchit.sh /sof/ && \
cp soflinux/patchit_server.sh /sof/

# only gets sof_demo and patchit scripts. so fine
WORKDIR sof
#creates sof-mp-server and sof-mp binaries
RUN /bin/bash patchit.sh && /bin/bash patchit_server.sh
RUN cp /soflinux/libXdmcp.so.6 ./

#---------------------------------------
# create the image to run it from
#---------------------------------------
#paks loaded
# Final
FROM i386/ubuntu:bionic

#dependencies
RUN apt-get -y update && apt-get -y install \
libgl1-mesa-glx \
libx11-6 \
libxext6 \
&& rm -rf /var/lib/apt/lists/*

#user_account
RUN adduser --disabled-password --gecos '' mullins
USER mullins
WORKDIR /home/mullins

# using 'cddir' option as 'static_files/base' to make a layered filesystem
RUN mkdir -p sof/static_files/base

# copy sof from the previous builder image
COPY --from=builder --chown=mullins /sof-ce/Base/basicpack2015v2.pak sof/static_files/base/
COPY --from=builder --chown=mullins /sof-ce/Base/pak*.pak sof/static_files/base/
COPY --from=builder --chown=mullins /sof sof/
COPY --from=builder --chown=mullins /sof/base sof/static_files/base


USER mullins
# /home/mullins/sof
WORKDIR sof
SHELL ["/bin/bash" , "-c"]

# this is now mounted from host
#RUN mkdir -p ~/.loki/sof && mkdir -p base
#COPY won_key /home/mullins/.loki/sof/

# linux faulty default gamma
# default_video.cfg overridden in "user' dir maxfps=150 and gamma=0
# i do this on the host instead.
#COPY default_video.cfg /home/mullins/.loki/sof/

USER root
RUN apt-get -y update && apt-get -y install gdb
#RUN apt-get -y install padsp
#RUN setcap cap_net_raw,cap_net_admin+eip /home/mullins/sof/sof-bin

# prepare to launch
USER mullins
#console says +set cddir write protected, but not true, it still reads it
#ENTRYPOINT ["/bin/bash","-c","./sof-bin +set cddir static_files +set console 1"]

# GL_STRINGS buffer fix
ENV MESA_EXTENSIONS_MAX_YEAR=2000
# vsync OFF
ENV vblank_mode=1

# libraries loadable
ENV LD_LIBRARY_PATH=.
# latest mesa version fix symbol clash libTitan __dynamic_cast
# AND _sl_add in liboasnd.so libbsd0.so
#ENV LD_PRELOAD="ref_gl.so liboasnd.so libstdc++.so.6"
#ENV LD_ASSUME_KERNEL=2.4.6

#sof has to ran in a shell, it seems
CMD ["./sof-bin" "+set cddir static_files","+set console 1"]

