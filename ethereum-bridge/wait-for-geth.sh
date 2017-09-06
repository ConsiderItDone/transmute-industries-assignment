#!/bin/bash

isGethRunning()
{
	blockNumber=$(curl -s -X POST --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":83}' http://"$1":8545 | jq --raw-output .result)
	echo "Block number is $blockNumber"
	[[ $blockNumber -gt 0 ]] 
}

cmd="$@"

until isGethRunning geth; do
  >&2 echo "Geth is unavailable - sleeping"
  sleep 1
done

>&2 echo "Geth is up - executing command"

exec $cmd
