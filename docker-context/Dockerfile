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
#sof_ce_installer.exe is built with the software: "Smart Install Maker"

# the higher the pakX.pak number, the more priority it has.
# I have given 1.06a pak2.pak highest priority
# And pak0.pak from sofdemo 2nd highest priority.
# Could be bad, just wanted everything to work, and not seem too forced 1.07f.
# I think we should move them to addons, and name them
# So that they can be deleted if necessary

#---------------------------------------------
# get all resources into one directory
#---------------------------------------------
FROM i386/ubuntu:bionic AS sofBuilder
ARG MANUAL_CE=""
#echo "deb [trusted=yes] http://ppa.launchpad.net/deadsnakes/ppa ubuntu bionic main" >> /etc/apt/sources.list
RUN apt-get -y update && \
apt-get install -y git xxd wine-stable xvfb \
&& rm -rf /var/lib/apt/lists/*

# ------------------SOF1.06a----------------
# Get 1.06a , rename pak2.pak -> pak6.pak, 1.06 extracts to '/sof'

RUN mkdir /sof && \
	git clone https://github.com/liflg/sof_1.06a-english_x86 && \
	tar -xvf sof_1.06a-english_x86/data/patch-1.06a.tar -C /sof && \
	mv /sof/base/pak2.pak /sof/base/liflg_pak2.pak

# automatic CE
RUN if [ -z ${MANUAL_CE} ]; then \
	apt-get -y update && apt-get -y install python3 python3-pip && pip3 install requests && rm -rf /var/list/apt/lists/*; \
	echo "\nPlease Standby, we are grabbing SoF Community Edition, its around 600MB, this could take a while.\n"; \
	git clone https://github.com/d3nd3/sof-ce-dl; \
	python3 sof-ce-dl/get.py; \
	fi
# MANUAL_CE not empty, thus we copy it from context
# If MANUAL_CE is set, it expands to become `.`
COPY ${MANUAL_CE:+sof_ce_installer.exe} /

# -------------SOF-COMMUNITYEDITION------------
# Extract SoF-CE, uses wine and xvfb to do so, extracts to '/sof-ce'
#RUN Xvfb :0 -nolisten tcp &
RUN xvfb-run wine sof_ce_installer.exe /s /l=English /p=./sof-ce

# Move imporant things in sof-ce to /sof?
#RUN cp sof-ce/Base/basicpack2015v2.pak sof/base/ && \
#cp sof-ce/Base/pak*.pak sof/base/

# ------------------SOFDEMO----------------
# Get soflinux repo(this repo) contains sof_demo
# Extract demo, copy demo pak0.pak into '/sof' as 'pak5.pak', move hex patches into '/sof'
# why pak5.pak and pak6.pak demo and 1.06a? too much priority?
#apply v1.07 compat patch
COPY sof_demo.tar.gz /
RUN tar -xvzf /sof_demo.tar.gz && \
cp /sof_demo/base/pak0.pak /sof/base/demo_pak0.pak

#------------------SOF-MP/SOF-MP-SERVER-----------------
WORKDIR sof
COPY patches/patchit.sh /sof/
COPY patches/patchit_server.sh /sof/
# Create sof-mp-server and sof-mp binaries
RUN /bin/bash patchit.sh && /bin/bash patchit_server.sh
COPY libXdmcp.so.6 .

#---------------------------------------
# Final Image to Run SoF with.
#---------------------------------------
FROM i386/ubuntu:bionic
ARG RUN_DOCKER_CLIENT=""
SHELL ["/bin/bash" , "-c"]

# Dependencies
RUN apt-get -y update && apt-get -y install \
libgl1-mesa-glx \
libx11-6 \
libxext6 \
&& rm -rf /var/lib/apt/lists/*

# User_account
RUN adduser --disabled-password --gecos '' mullins
USER mullins
WORKDIR /home/mullins

# ------------- ENSURE DIRECTORYS EXIST ---------------
# This directory is used internally to the container
#./sof/static_files/base created by below COPY command
RUN mkdir -p /home/mullins/sof/static_files/base
# Important creation of folders that will be mounted to at runtime.
# [$basedir extension] ./.loki/sof-addons/base created by below COPY command
# The contents of this folder will be copied to the host at `build time`.
RUN mkdir -p /home/mullins/.loki/sof-addons/base

# [$user] ~/.loki/sof
RUN mkdir -p /home/mullins/.loki/sof

# copy sof from the previous builder image
COPY --from=sofBuilder --chown=mullins /sof-ce/Base/basicpack2015v2.pak ./sof/static_files/base/
COPY --from=sofBuilder --chown=mullins /sof-ce/Base/pak*.pak ./sof/static_files/base/
COPY --from=sofBuilder --chown=mullins /sof/base/player.so /sof/base/gamex86.so ./sof/static_files/base/


COPY --from=sofBuilder --chown=mullins /sof/base/liflg_pak2.pak ./.loki/sof-addons/base/
COPY --from=sofBuilder --chown=mullins /sof/base/demo_pak0.pak /home/mullins/.loki/sof-addons/base/
#COPY --from=sofBuilder --chown=mullins /sof/base/gamex86.so /home/mullins/.loki/sof-addons/base/
#COPY --from=sofBuilder --chown=mullins /sof/base/player.so /home/mullins/.loki/sof-addons/base/
COPY --from=sofBuilder --chown=mullins /sof/*.so* ./sof/
COPY --from=sofBuilder --chown=mullins /sof/sof-bin /sof/sof-mp /sof/sof-mp-server ./sof/

# /home/mullins/sof
WORKDIR sof

#RUN setcap cap_net_raw,cap_net_admin+eip /home/mullins/sof/sof-bin
USER root
RUN if [ ! -z "${RUN_DOCKER_CLIENT}" ]; then \
      echo "\nInstalling mesa && pulseaudio because you will use the container as client.\n"; \
      # OSSPD Necessary for WSL users and gives us padsp for NON-WSL users
      apt-get -y update && apt-get -y install gdb mesa-utils osspd && \
      rm -rf /var/lib/apt/lists/*; \
    fi

# prepare to launch
USER mullins
#console says +set cddir write protected, but not true, it still reads it

# GL_STRINGS buffer fix
ENV MESA_EXTENSIONS_MAX_YEAR=2000

# libraries loadable
ENV LD_LIBRARY_PATH=.

ENV LD_PRELOAD="libstdc++.so.6"

# do we want docker run to contribute to cmdline? (yes)
# these are just defaults. Lets echo that they should use the run scripts
CMD ["echo" "use the run scripts, do not run like this."]

