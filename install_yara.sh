#!/bin/bash

# sort versions in reverse order - newest to oldest
ALL_VERSIONS=( $(git ls-remote --tags https://github.com/VirusTotal/yara.git | grep -Eio "refs/tags/v[0-9\.]+$" | sed -e 's@refs/tags/v@@' | sort -Vr) )
# latest version is used in case user does not provide input
USR_INPUT=${ALL_VERSIONS[0]}

# if the user provided input, use that instead
if [ ! -z ${INPUT_YARA-VERSION} ]
then
    USR_INPUT="${INPUT_YARA-VERSION}"
fi

function resolve_version {
    echo "Available YARA versions: ${ALL_VERSIONS[*]}"
    if [[ " ${ALL_VERSIONS[@]} " =~ " ${USR_INPUT} " ]]
    then
        echo "${USR_INPUT} is a valid version"
        YARA_VERSION="${USR_INPUT}"
    # gonna have to update version regex when 4+ comes up
    elif [[ $USR_INPUT =~ ^[1-3](\.[0-9]{1,2})?$ ]]
    then
        echo "${USR_INPUT} looks like a possible version number"
        # let's loop through to get the most up-to-date matching version
        for i in "${ALL_VERSIONS[@]}"
        do
            pattern="^${USR_INPUT}.*"
            if [[ $i =~ $pattern ]]
            then
                YARA_VERSION=$i
                break
            fi
        done
    else
        echo "Could not resolve version number for ${USR_INPUT}. Exiting"
        exit 1
    fi
}

function install_yara {
    echo "Installing YARA v$YARA_VERSION"
    git clone --recursive --branch v$YARA_VERSION https://github.com/VirusTotal/yara.git
    cd ./yara/
    ./bootstrap.sh
    ./configure --with-crypto --enable-magic --enable-cuckoo --enable-dotnet
    make
    make install
    make check
    cd .. && rm -rf ./yara/
    # gotta make sure the libyara path is available to load from
    ldconfig /usr/local/lib
}

resolve_version
if [[ ! -z ${YARA_VERSION} ]]
then
    install_yara
fi
