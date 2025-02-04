# Use the most recent Ubuntu LTS version
FROM ubuntu:latest

LABEL maintainer="thomas@infosec-intern.com"

ARG INPUT_RULES
ARG INPUT_FLAGS
ARG GITHUB_WORKSPACE
WORKDIR /tmp
COPY LICENSE README.md /
COPY entrypoint.sh /tmp/entrypoint.sh
COPY ${INPUT_RULES} ${GITHUB_WORKSPACE}/rules/

RUN apt-get -qq update && apt-get install -qq -y \
    automake \
    bison \
    flex \
    gcc \
    git \
    libjansson-dev \
    libmagic-dev \
    libssl-dev \
    libtool \
    make
RUN chmod +x /tmp/entrypoint.sh

ENTRYPOINT [ "/tmp/entrypoint.sh" ]
