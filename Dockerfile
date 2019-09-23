# Slightly modified from https://hub.docker.com/r/blacktop/yara/dockerfile
# Use the most recent Ubuntu LTS version
FROM ubuntu:latest

LABEL maintainer="thomas@infosec-intern.com"

COPY LICENSE README.md /
COPY entrypoint.sh /tmp/entrypoint.sh

WORKDIR /tmp

ARG YARA_VERSION="3.10.0"

RUN apt-get -q update
RUN apt-get install -q -y automake bison flex gcc git libjansson-dev libmagic-dev libssl-dev libtool make
RUN echo "Installing Yara v$YARA_VERSION" \
    && git clone --recursive --branch v$YARA_VERSION https://github.com/VirusTotal/yara.git \
    && cd /tmp/yara \
    && ./bootstrap.sh \
    && ./configure --with-crypto --enable-magic --enable-cuckoo --enable-dotnet \
    && make \
    && make install

ENTRYPOINT [ "yarac" ]
CMD [ "--help" ]
