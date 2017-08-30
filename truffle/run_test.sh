#!/bin/bash

# Get the directory of where this script is.
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ] ; do SOURCE="$(readlink "$SOURCE")"; done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

if [ -z "$OAR" ]; then
    echo "Need to set OAR variable"
    exit 1
fi

sed -i "s/_OAR_/$OAR/g" "$DIR/contracts/YoutubeViews.sol"

truffle test/youtube.js
