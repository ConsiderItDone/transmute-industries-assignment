#!/bin/bash

set -eu

isOARGenerated()
{
    OARDIR=$1
    COUNT_JS_FILES=$(ls -l $OARDIR/*.json | wc -l)

	#echo $COUNT_JS_FILES
	[[ $COUNT_JS_FILES -gt 0 ]]
}

# Get the directory of where this script is.
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ] ; do SOURCE="$(readlink "$SOURCE")"; done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

#clean up
rm -rf "$DIR/files/instance"

set +e
docker network rm oraclize_network
set +e

# create network
docker network create --driver bridge --subnet 172.59.0.0/16 oraclize_network

# Start docker-compose
docker-compose up --build -d

# build image with truffle test
docker build -t oraclize-truffle -f truffle/Dockerfile truffle

# get geth IP
GETH_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' oraclize-geth)
echo "geth ip is $GETH_IP"

# wait for ethereum network
echo "Waiting for ethereum network and ethereum bridge..."

until isOARGenerated "$DIR/files/instance"; do
  >&2 echo "OAR dir is empty. Sleeping 10 s"
  sleep 10
done

# extract oar
OAR=$(docker run --rm -it -v "$DIR/files/instance:/tmp/instance" -e OAR_DIR=/tmp/instance oraclize-truffle node extractOar.js)
echo "OAR is $OAR"

#set OAR in smart contract
docker run --rm -it -e OAR=$OAR -e ETH_HOST=$GETH_IP --network=oraclize_network oraclize-truffle bash run_test.sh
#docker run --network=oraclize_oraclize_network --rm -it -e OAR=$OAR -e ETH_HOST=$GETH_IP oraclize-truffle bash


# stop and remove containers
docker-compose stop && docker-compose rm -f
