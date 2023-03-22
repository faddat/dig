#!/bin/bash
# microtick and bitcanna contributed significantly here.
set -uxe

# set environment variables
# don't use a / after the rpc URL's
# "RPCN == you can put N rpc's here, comma separated list"
export GOPATH=~/go
export PATH=$PATH:~/go/bin
export RPC="http://65.108.199.222:26777"
export RPCN="http://65.108.199.222:26777"
export APPNAME=DIGD

# Install Dig
go install ./...

# MAKE HOME FOLDER AND GET GENESIS
digd init test
cp networks/mainnets/dig-1/genesis.json ~/.dig/config

INTERVAL=1000

# GET TRUST HASH AND TRUST HEIGHT

LATEST_HEIGHT=$(curl -s $RPC/block | jq -r .result.block.header.height);
BLOCK_HEIGHT=$(($LATEST_HEIGHT-$INTERVAL)) 
TRUST_HASH=$(curl -s "$RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)


# TELL USER WHAT WE ARE DOING
echo "TRUST HEIGHT: $BLOCK_HEIGHT"
echo "TRUST HASH: $TRUST_HASH"


# export state sync vars
export $(echo $APPNAME)_STATESYNC_ENABLE=true
export $(echo $APPNAME)_P2P_MAX_NUM_OUTBOUND_PEERS=200
export $(echo $APPNAME)_P2P_MAX_NUM_INBOUND_PEERS=500
export $(echo $APPNAME)_STATESYNC_RPC_SERVERS="$RPC,$RPCN"
export $(echo $APPNAME)_STATESYNC_TRUST_HEIGHT=$BLOCK_HEIGHT
export $(echo $APPNAME)_STATESYNC_TRUST_HASH=$TRUST_HASH
export $(echo $APPNAME)_P2P_LADDR=tcp://0.0.0.0:2220
export $(echo $APPNAME)_RPC_LADDR=tcp://127.0.0.1:2221
export $(echo $APPNAME)_GRPC_ADDRESS=127.0.0.1:2222
export $(echo $APPNAME)_API_ADDRESS=127.0.0.1:2223
export $(echo $APPNAME)_GRPC_WEB_ADDRESS=127.0.0.1:2224
export $(echo $APPNAME)_P2P_SEEDS="37b2839da4463b22a51b1fe20d97992164270eba@62.171.157.192:26656,e2c96b96d4c3a461fb246edac3b3cdbf47768838@65.21.202.37:6969,33f4788e1c6a378b929c66f31e8d253b9fd47c47@194.163.154.251:26656,64eccffdc60a206227032d3a021fbf9dfc686a17@194.163.156.84:26656,be7598b2d56fb42a27821259ad14aff24c40f3d2@172.16.152.118:26656,f446e37e47297ce9f8951957d17a2ae9a16db0b8@137.184.67.162:26656,ab2fa2789f481e2856a5d83a2c3028c5b215421d@144.91.117.49:26656,e9e89250b40b4512237c77bd04dc76c06a3f8560@185.214.135.205:26656,1539976f4ee196f172369e6f348d60a6e3ec9e93@159.69.147.189:26656,85316823bee88f7b05d0cfc671bee861c0237154@95.217.198.243:26656,eb55b70c9fd8fc0d5530d0662336377668aab3f9@185.194.219.128:26656"
export $(echo $APPNAME)_P2P_PERSISTENT_PEERS="be0987bf68af305622e99c1de8c1f78c30141c6b@65.108.238.104:16356,b566fc53ea9ca6945d408a58f67da000960cf013@[2a01:4f8:202:331b::12]:26656,3a3a9c1fc144ed97ff2e716751d7756c07f725c5@65.21.111.181:26656,fbfe395f2eb2a5eaa52fcdf3e8991d4f83e7a8be@dig.p2p.brocha.in:30507,08453e876ce173de43820693c06be805100a433e@5.161.63.236:26656"

digd start --minimum-gas-prices 0.00001udig
