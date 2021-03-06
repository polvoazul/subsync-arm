# https://hub.docker.com/r/bramfr/docker-subsync/dockerfile

FROM amd64/python:3.7.5-buster

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

RUN pip install .

ENTRYPOINT ["python3", "/subsync/run.py"]
