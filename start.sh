#!/bin/bash

set -eu

# Get the directory of where this script is.
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ] ; do SOURCE="$(readlink "$SOURCE")"; done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

#clean up
rm -rf "$DIR/files/instance"

# Start docker-compose
docker-compose up -d

# build image with truffle test
docker build -t oraclize-truffle -f truffle/Dockerfile truffle

# get geth IP
GETH_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' oraclize-geth)
echo "geth ip is $GETH_IP"

# wait for ethereum network
echo "Waiting for ethereum network and ethereum bridge..."
sleep 280

# extract oar
OAR=$(docker run --rm -it -v "$DIR/files/instance:/tmp/instance" -e OAR_DIR=/tmp/instance oraclize-truffle node extractOar.js)
echo "OAR is $OAR"

#set OAR in smart contract
docker run --rm -it -e OAR=$OAR -e ETH_HOST=$GETH_IP --network=oraclize_oraclize_network oraclize-truffle bash run_test.sh
#docker run --network=oraclize_oraclize_network --rm -it -e OAR=$OAR -e ETH_HOST=$GETH_IP oraclize-truffle bash


# stop and remove containers
docker-compose stop && docker-compose rm -f
