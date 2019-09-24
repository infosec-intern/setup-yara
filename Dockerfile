# Use the most recent Ubuntu LTS version
FROM ubuntu:latest

LABEL maintainer="thomas@infosec-intern.com"

WORKDIR /tmp
COPY LICENSE README.md /
COPY hello.sh /tmp/hello.sh
# COPY install_yara.sh /tmp/install_yara.sh

# RUN apt-get -q update && apt-get install -q -y \
#     automake \
#     bison \
#     flex \
#     gcc \
#     git \
#     libjansson-dev \
#     libmagic-dev \
#     libssl-dev \
#     libtool make
# RUN chmod +x /tmp/install_yara.sh

# ENTRYPOINT [ "/tmp/install_yara.sh" ]
ENTRYPOINT [ "/tmp/hello.sh" ]
