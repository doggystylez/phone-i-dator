#!/bin/bash

## this one might actually be useful. prints a list of nodes connected to the reference node
## either all peers, or only outbound peers

RED='\033[0;91m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'
printf "\n${RED}rpc${NC} address?: "
read RPC
printf "\n${RED}filter${NC} outbound only? (y/n): "
read FILTER
DATA=$(curl -s $RPC/net_info)
COUNT=$(echo $DATA | jq '.result | .n_peers' | tr -d '"')
x=0
if [ $FILTER == 'y' ]
then
  printf "\nlist of ${BLUE}outbound${NC} peers only:\n\n"
  while [ $x -lt $COUNT ]
  do
    if [ $(echo $DATA | jq ".result | .peers | .[$x] | .is_outbound") == 'true' ]
    then
      ID=$(echo $DATA | jq ".result | .peers | .[$x] | .node_info | .id" 2> /dev/null)
      ADDRESS=$(echo $DATA | jq ".result | .peers | .[$x] | .remote_ip" 2> /dev/null)
      PORT=$(echo $DATA | jq ".result | .peers | .[$x] | .node_info | .listen_addr" 2> /dev/null | tr -d '"')
      PEER=$(echo $ID | tr -d '"')@$(echo $ADDRESS | tr -d '"'):${PORT##*:}
      echo $PEER
      ((x++))
    else
      ((x++))
    fi
  done
  printf "\n"
else
  printf "\nlist of all ${GREEN}connected${NC} peers:\n\n"
  while [ $x -lt $COUNT ]
  do
    ID=$(echo $DATA | jq ".result | .peers | .[$x] | .node_info | .id" 2> /dev/null)
    ADDRESS=$(echo $DATA | jq ".result | .peers | .[$x] | .remote_ip" 2> /dev/null)
    PORT=$(echo $DATA | jq ".result | .peers | .[$x] | .node_info | .listen_addr" 2> /dev/null | tr -d '"')
    PEER=$(echo $ID | tr -d '"')@$(echo $ADDRESS | tr -d '"'):${PORT##*:}
    echo $PEER
    ((x++))
  done
  printf "\n"
fi
