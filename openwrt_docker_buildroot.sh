#!/usr/bin/env bash
# shellcheck disable=SC1090
#
# Generate build and oragnize images based on revisions
#
# Copyright (c) 2019 Ganesh Velu. Released under the MIT License.

set -e

if [[ -f "${coltable}" ]]; then
    source ${coltable}
else
    COL_NC='\e[0m' # No Color
    COL_MAG='\e[1;35m'
    COL_CYAN='\e[1;36m'
    COL_BLUE='\e[1;34m'
    COL_RED='\e[1;31m'
    COL_LIGHT_RED='\e[1;91m'
    COL_YELLOW='\e[1;33m'
    COL_LBLUE='\e[1;93m'
    COL_LYELLOW='\e[1;94m'
fi

if [[ ! "$EUID" -ne 0 ]]; then
    echo "\n${COL_RED}Sorry, you cannot run this as root!${COL_NC}"
    exit
fi

OPENWRT_PATH="/home/openwrt/openwrt"
OUTPUT_DIR="/home/openwrt/public/snapshots"
WORKING_PATH=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
SNAPSHOT_DIRECTORY="/home/openwrt/public/snapshots"
MAX_SNAPSHOTS=10
if [[ ! -d "$SNAPSHOT_DIRECTORY" ]]; then
    mkdir "$SNAPSHOT_DIRECTORY"
fi
SNAPSHOTS_FOUND=$(find $SNAPSHOT_DIRECTORY/* -maxdepth 0 -type d | wc -l)


echo -e "\n${COL_LBLUE}Entering Directory $WORKING_PATH ${COL_NC}"
cd "$WORKING_PATH"

if [[ -d "$OPENWRT_PATH" ]]; then
    cd "$OPENWRT_PATH"
    GIT_REPO_VALID="$(git rev-parse --is-inside-work-tree 2>/dev/null)"
    GIT_REPO_NAME="$(basename `git rev-parse --show-toplevel 2>/dev/null` 2>/dev/null)"
    if [[ ! $GIT_REPO_VALID ]] && [[ ! "$GIT_REPO_NAME" = "openwrt" ]]; then
        echo -e "\n${COL_RED}OpenWRT Path is not a valid openwrt.git repo, please revise!${COL_NC}"
        exit 1
    fi
else
    while true; do
        read -p "\nNo OpenWRT build directory was found, Would you like to clone one? (y/N)" input_choice
        case "$input_choice" in
            [yY]*)
                echo -e "\n${COL_LBLUE}Cloning OpenWRT Master Repository ${COL_NC}"
                git clone https://git.openwrt.org/openwrt/openwrt.git -b 'master'
                return
                ;;
            [nN]*)
                return
                ;;
            *)
                echo 'Invalid input' >&2
        esac
    done
fi

echo -e "\n${COL_LBLUE}Running docker container ${COL_NC}"
docker run -it --rm docker.io/iganesh/openwrt-snapshot-builder:latest bash -c './snapshot_builder.sh "$OPENWRT_PATH"'

SNAPSHOT_VER=$(cat "$OPENWRT_PATH/SNAPSHOT_VER")

if [[ ! -d "$OUTPUT_DIR" ]]; then
    mkdir "$OUTPUT_DIR"
fi

mv "$OPENWRT_PATH/bin/$SNAPSHOT_VER" "$OUTPUT_DIR"

echo -e "\n${COL_MAG}$SNAPSHOT_VER$ ${COL_BLUE}build successfully deployed!${COL_NC}"

if [ "$SNAPSHOTS_FOUND" -gt "$MAX_SNAPSHOTS" ];then
    echo -e "\n${COL_BLUE}Snapshots limit exceeded! Rotating...${COL_NC}"
    echo -e "\n${COL_RED}Removing $(find $SNAPSHOT_DIRECTORY/* -maxdepth 0 -type d | head -n1)${COL_NC}"
    rm -rf $(find $SNAPSHOT_DIRECTORY/* -maxdepth 0 -type d | head -n1)
fi

echo -e "\n${COL_MAG}End of automated snapshot generation script.\n${COL_NC}"
