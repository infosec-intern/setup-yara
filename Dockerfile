# Slightly modified from https://hub.docker.com/r/blacktop/yara/dockerfile
# Use the most recent Ubuntu LTS version
FROM ubuntu:latest

LABEL maintainer="thomas@infosec-intern.com"

COPY LICENSE README.md /
COPY entrypoint.sh /tmp/entrypoint.sh

WORKDIR /tmp

RUN apt-get -q update
RUN apt-get install -q -y automake bison flex gcc git libjansson-dev libmagic-dev libssl-dev libtool make
RUN /bin/bash -c "/tmp/entrypoint.sh"

ENTRYPOINT [ "yarac" ]
CMD [ "--help" ]
