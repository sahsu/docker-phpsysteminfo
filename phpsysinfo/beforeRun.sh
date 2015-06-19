#!/bin/sh

LATEST_VERSION=$(wget -O - https://api.github.com/repos/phpsysinfo/phpsysinfo/tags 2>/dev/null | grep name | grep v | sort -r | head -1 | cut -d '"' -f 4 | cut -c 2-)
DOWNLOAD_URL=https://github.com/phpsysinfo/phpsysinfo/archive/v${LATEST_VERSION}.tar.gz
TARGET_FILE=/tmp/phpsysinfo-${LATEST_VERSION}.tar.gz

if [ ! -f /opt/phpsysinfo/phpsysinfo.ini ]; then
    mkdir -p /opt/

    echo "-- Downloading ${DOWNLOAD_URL} to ${TARGET_FILE}"
    wget -O $TARGET_FILE ${DOWNLOAD_URL}

    cd /opt
    tar xfz $TARGET_FILE
    rm $TARGET_FILE
    mv /opt/phpsysinfo-${LATEST_VERSION}  /opt/phpsysinfo
    mv /opt/phpsysinfo/phpsysinfo.ini.new /opt/phpsysinfo/phpsysinfo.ini
fi