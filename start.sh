#!/bin/bash

set -eu

# Start docker-compose
docker-compose up -d

# build image with truffle test
docker build -t oraclize-truffle -f truffle/Dockerfile truffle

# get geth IP
GETH_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' oraclize-geth)
echo "geth ip is $GETH_IP"

# wait for ethereum network
sleep 120

# extract oar

# stop and remove containers
docker-compose stop && docker-compose rm -f