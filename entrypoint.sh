#!/bin/sh -l

if [ $# -eq 0 ]
then
    export YARA_VERSION = "3.10.0"
else
    export YARA_VERSION = "$1"
fi

echo "Installing Yara v$YARA_VERSION"

git clone --recursive --branch v$YARA_VERSION https://github.com/VirusTotal/yara.git
cd /tmp/yara
./bootstrap.sh
./configure --with-crypto --enable-magic --enable-cuckoo --enable-dotnet
make
make install
