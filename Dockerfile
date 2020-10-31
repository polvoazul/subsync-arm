# https://hub.docker.com/r/bramfr/docker-subsync/dockerfile
# but arm

FROM alpine AS builder

# Download QEMU, see https://github.com/docker/hub-feedback/issues/1261
ENV QEMU_URL https://github.com/balena-io/qemu/releases/download/v3.0.0%2Bresin/qemu-3.0.0+resin-aarch64.tar.gz
RUN apk add curl && curl -L ${QEMU_URL} | tar zxvf - -C . --strip-components 1

FROM arm64v8/python:3.7

# Add QEMU
COPY --from=builder qemu-aarch64-static /usr/bin

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
  && apt-get update -q \
  && apt-get install -qy swig ffmpeg libsphinxbase-dev gcc automake autoconf libasound2-dev python3-dev python3-pip build-essential swig git libpulse-dev libtool bison swig libavutil-dev libswscale-dev python3-dev libpulse-dev libpocketsphinx-dev libavformat-dev libswresample-dev libavdevice-dev libavfilter-dev python3-pocketsphinx \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


RUN pip3 install pocketsphinx

RUN git clone -b '0.16' https://github.com/sc0ty/subsync.git

WORKDIR /subsync

RUN cp subsync/config.py.template subsync/config.py
RUN pip3 install -r requirements.txt
WORKDIR /subsync/gizmo

RUN python3 setup.py build
RUN python3 setup.py install

WORKDIR /subsync

RUN python3 setup.py build
RUN python3 setup.py install

ENTRYPOINT [ "python3", "./subsync.py" ]


