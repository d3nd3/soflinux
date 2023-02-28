FROM i386/ubuntu:16.04

COPY libbsd-0.2.0 /libbsd
WORKDIR libbsd

RUN apt-get -y update && apt-get -y install make gcc libc6-dev
RUN make
