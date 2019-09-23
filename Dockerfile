# Slightly modified from https://hub.docker.com/r/blacktop/yara/dockerfile
# Use the most recent Ubuntu LTS version
FROM ubuntu:latest

COPY LICENSE README.md /
COPY entrypoint.sh /entrypoint.sh

RUN apt install automake bison flex gcc git libjansson-dev libmagic-dev libssl-dev libtool make
RUN echo "Install Yara from source..." \
    && cd /tmp/ \
    && git clone --recursive --branch v$YARA_VERSION https://github.com/VirusTotal/yara.git \
    && cd /tmp/yara \
    && ./bootstrap.sh \
    && ./configure --with-crypto --enable-magic --enable-cuckoo --enable-dotnet \
    && make \
    && make install \
    && rm -rf /tmp/*

VOLUME ["/malware"]
VOLUME ["/rules"]

WORKDIR /malware

ENTRYPOINT ["/entrypoint.sh"]
