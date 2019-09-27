#!/bin/bash

# sort versions in reverse order - newest to oldest
ALL_VERSIONS=( $(git ls-remote --tags https://github.com/VirusTotal/yara.git | grep -Eio "refs/tags/v[0-9\.]+$" | sed -e 's@refs/tags/v@@' | sort -Vr) )
# latest version is used in case user does not provide input
USER_INPUT=${ALL_VERSIONS[0]}

# if the user provided input, use that instead
if [[ ! -z ${1} ]]
then
    USER_INPUT=${1}
fi

function resolve_version {
    echo "Available YARA versions: ${ALL_VERSIONS[*]}"
    if [[ " ${ALL_VERSIONS[@]} " =~ " ${USER_INPUT} " ]]
    then
        echo "${USER_INPUT} is a valid version"
        YARA_VERSION="${USER_INPUT}"
    # gonna have to update version regex when 4+ comes up
    elif [[ $USER_INPUT =~ ^[1-3](\.[0-9]{1,2})?$ ]]
    then
        echo "${USER_INPUT} looks like a possible version number"
        # let's loop through to get the most up-to-date matching version
        for i in "${ALL_VERSIONS[@]}"
        do
            pattern="^${USER_INPUT}.*"
            if [[ $i =~ $pattern ]]
            then
                YARA_VERSION=$i
                break
            fi
        done
    else
        echo "Could not resolve version number for ${USER_INPUT}. Exiting"
        exit 1
    fi
}

function install_yara {
    echo "Installing YARA v${YARA_VERSION}"
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
    install_yara && echo "Successfully installed $(yara -v)" || exit 1
    YARA_RULES="/tmp/rules/${INPUT_RULES}"
    YARA_FLAGS="${INPUT_FLAGS}"
    echo "yarac ${YARA_FLAGS} ${YARA_RULES} /tmp/rules/yarac.out"
    OUTPUT=$(yarac ${YARA_FLAGS} ${YARA_RULES} "/tmp/rules/yarac.out")
    if [[ $OUTPUT =~ "error" ]]
    then
        # /tmp/rules/rule.yara(22): error: syntax error, unexpected '{', expecting identifier
        FILENAME=$(echo $OUTPUT | cut -d' ' -f 1 | cut -d'(' -f 1)
        LINENO=$(echo $OUTPUT | cut -d' ' -f 1 | cut -d'(' -f 2 | grep -Eio "[0-9]+?")
        ERRMSG=$(echo $OUTPUT | cut -d' ' -f 3-)
        echo ::error file="${FILENAME}",line="${LINENO}"::"${ERRMSG}"
        exit 1
    elif [[ $OUTPUT =~ "warning" ]]
    then
        # /tmp/rules/rule.yara(3): warning: Using deprecated "entrypoint" keyword. Use the "entry_point" function from PE module instead.
        FILENAME=$(echo $OUTPUT | cut -d' ' -f 1 | cut -d'(' -f 1)
        LINENO=$(echo $OUTPUT | cut -d' ' -f 1 | cut -d'(' -f 2 | grep -Eio "[0-9]+?")
        ERRMSG=$(echo $OUTPUT | cut -d' ' -f 3-)
        echo ::warning file="${FILENAME}",line="${LINENO}"::"${ERRMSG}"
    fi
    # if we get here, we either passed with no errors or only warnings - the run succeeded!
    exit 0
else
    echo "Some kind of bug occurred in resolve_version. Review logs for details. Exiting"
    exit 1
fi
