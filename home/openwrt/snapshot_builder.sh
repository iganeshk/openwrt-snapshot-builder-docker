#!/usr/bin/env bash
# shellcheck disable=SC1090

set -e

OPENWRT_PATH=$1

function getWRTver	{
	./scripts/getver.sh
}

function runWhileChecking	{
    "$@"
    local status=$?
    if [ $status -ne 0 ]; then
        # echo "error with $1" >&2
        echo -e "\n$Could not complete build!" >&2
        exit
    fi
    # return $status
}


if [[ -f "${coltable}" ]]; then
    source ${coltable}
else
    COL_NC='\e[0m' # No Color
    COL_MAG='\e[1;35m'
    COL_CYAN='\e[1;36m'
    COL_BLUE='\e[1;34m'
    COL_LIGHT_RED='\e[1;31m'
    COL_YELLOW='\e[1;33m'
    COL_LBLUE='\e[1;93m'
    COL_LYELLOW='\e[1;94m'
fi

if [[ -d "$OPENWRT_PATH" ]]; then
    cd "$OPENWRT_PATH"
elif [[ -d "./openwrt" ]]; then
    cd ./openwrt
else
    echo -e "\n${COL_RED}Unable to locate OPENWRT build directory, try passing it as an argument?${COL_NC}"
    exit 1
fi

echo -e "\n${COL_LBLUE}Entering Directory $OPENWRT_PATH ${COL_NC}"
GIT_REPO_VALID="$(git rev-parse --is-inside-work-tree 2>/dev/null)"
GIT_REPO_NAME="$(basename `git rev-parse --show-toplevel 2>/dev/null` 2>/dev/null)"
if [[ ! $GIT_REPO_VALID ]] && [[ ! "$GIT_REPO_NAME" = "openwrt" ]]; then
    exit 1
fi

echo -e "\n${COL_CYAN}Current Version: ${COL_YELLOW}$(getWRTver)${COL_NC}"

echo -e "\n${COL_MAG}Updating repository...${COL_NC}"
git pull
echo -e "\n${COL_MAG}Updating patches...${COL_NC}"
./scripts/feeds update -a
echo -e "\n${COL_MAG}Applying patches...${COL_NC}"
./scripts/feeds install -a
echo -e "\n${COL_MAG}Base files up-to date.${COL_NC}"

echo -e "\n${COL_MAG}Updating configuration (.config)${COL_NC}"
make defconfig

SNAPSHOT_VER=$(getWRTver) 
echo "$SNAPSHOT_VER" > ./SNAPSHOT_VER

echo -e "\n${COL_BLUE}Building Snapshot ${COL_YELLOW}$SNAPSHOT_VER${COL_NC}"
rm -rf ./bin/*
# Build the images while checking their status
runWhileChecking make download
runWhileChecking make -j2

echo -e "\n${COL_BLUE}Target successfully built!${COL_NC}"

mkdir "./bin/$SNAPSHOT_VER"
mv ./bin/packages "./bin/$SNAPSHOT_VER"
mv ./bin/targets "./bin/$SNAPSHOT_VER"
echo -e "\n${COL_BLUE}Moved target files to appropriate snapshot directory.${COL_NC}\n"
exit 0
