# MAINNET: DIG-1

## Installation Steps

### Install Prerequisites 

The following are necessary to build dig from source. 

#### 1. Basic Packages
```bash:
# update the local package list and install any available upgrades 
sudo apt-get update && sudo apt upgrade -y 
# install toolchain and ensure accurate time synchronization 
sudo apt-get install make build-essential gcc git jq chrony -y
```

#### 2. Install Go
Follow the instructions [here](https://golang.org/doc/install) to install Go.

Alternatively, for Ubuntu LTS, you can do:
```bash:
wget https://golang.org/dl/go1.17.5.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.17.5.linux-amd64.tar.gz
```

Unless you want to configure in a non standard way, then set these in the `.profile` in the user's home (i.e. `~/`) folder.

```bash:
cat <<EOF >> ~/.profile
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export GO111MODULE=on
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
EOF
source ~/.profile
go version
```
Output should be: `go version go1.17.5 linux/amd64`

### Install Dig from source

#### 1. Clone repository
```bash:
git clone https://github.com/notional-labs/dig.git
cd dig
make install
```
Note: there is no tag to build off of, just use master for now

### Init chain
```bash:
digd init $MONIKER_NAME --chain-id dig-1
```

### Add/recover keys
```bash:
# To create new keypair - make sure you save the mnemonics!
digd keys add <key-name> 

# Restore existing odin wallet with mnemonic seed phrase. 
# You will be prompted to enter mnemonic seed. 
digd keys add <key-name> --recover
```

## Instructions for NEW Genesis Validators


### GenTx Creation

### Create Gentx

#### Add genesis account:
```
digd add-genesis-account <key-name> 10000000udig
```
Note: If you have validated dig already, you do not need to follow these directions and should find yourself in possession of about 675372 dig.  Thank you!
If the chain hasn't yet started the `digd q bank balances` command won't function, you will have to check the genesis.json manually for your allocation:
https://github.com/notional-labs/dig/blob/master/networks/mainnet/genesis.json

#### Create Gentx
```
digd gentx <key-name> 10000000udig \
--chain-id dig-1 \
--moniker="<moniker>" \
--commission-max-change-rate=0.01 \
--commission-max-rate=0.20 \
--commission-rate=0.05 \
--details="XXXXXXXX" \
--security-contact="XXXXXXXX" \
--website="XXXXXXXX"
```

### Submit PR with Gentx and peer id
1. Copy the contents of ${HOME}/.dig/config/gentx/gentx-XXXXXXXX.json.
2. Fork the repository
3. Create a file gentx-{{VALIDATOR_NAME}}.json under the networks/mainnet/gentx folder in the forked repo, paste the copied text into the file.
4. Create a Pull Request to the main branch of the repository


### Backup critical files
```bash:
priv_validator_key.json
```


# For people who've already validated
If you were in the testnets, but didn't have a gentx in testnet-3 this one is for you!


```bash
git clone https://github.com/notional-labs/dig
cd dig
go install ./...
cp networks/mainnet/genesis.json ~/.dig/config
digd gentx <key-name> 10000000udig \
--chain-id dig-1 \
--moniker="<moniker>" \
--commission-max-change-rate=0.01 \
--commission-max-rate=0.20 \
--commission-rate=0.05 \
--details="XXXXXXXX" \
--security-contact="XXXXXXXX" \
--website="XXXXXXXX"
cp ~/.dig/config/gentx/* networks/mainnet/gentx
git add .
git commit -m "Gentx submission for xyz validator"
git push
```

NB: You can set the commission max change rate, commission-max-rate, and commission-rate values to whatever you'd like though the chain begins with a minimum comission of 5% (0.05), so don't set it below that.


