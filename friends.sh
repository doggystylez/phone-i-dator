#!/bin/bash

## a simple script to check who your friends are
## requires cowsay

DATA=$(curl -s localhost:26657/net_info)
if [ "$DATA" == "" ]
then
  PEERS=0
else
  PEERS=$(echo $DATA  | jq '.result | .n_peers' | tr -d '"')
fi

x=0
while [ $x -lt $PEERS  ]
do
   MON=$(echo $DATA | jq ".result |.peers | .[$x] | .node_info | .moniker")
   printf "\e[31m$MON \n"
   ((x++))
done
printf "\e[1;33m$PEERS friends connected" | cowsay
