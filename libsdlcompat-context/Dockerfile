FROM i386/ubuntu:20.04

ARG TZ=Europe/London
ENV TZ $TZ
RUN apt-get -y update && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && DEBIAN_FRONTEND="noninteractive" apt-get -y update && apt-get -y install git make cmake build-essential libsdl2-dev libgl-dev && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/libsdl-org/sdl12-compat
WORKDIR sdl12-compat


RUN cmake -DCMAKE_BUILD_TYPE=Release .
RUN cmake --build .


WORKDIR /
RUN git clone https://github.com/libsdl-org/SDL.git -b SDL2
WORKDIR /SDL
RUN mkdir build
WORKDIR /SDL/build
RUN ../configure
RUN make
RUN make install


#SDL3
#RUN mkdir BUILD
#RUN cmake -S /SDL -B /BUILD && cmake --build /BUILD && cmake --install /BUILD


CMD ["echo" "done"]
