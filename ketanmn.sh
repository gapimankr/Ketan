#!/bin/sh

NONE='\033[00m'
RED='\033[01;91m'
GREEN='\033[01;32m'

echo "${RED}Installing required packages, done in 3 steps. ${NONE}";

echo "${RED}1. Do you like install swap file? (y) or (n) ${NONE}";
read SWAPQ
if [ $SWAPQ = 'y' ] || [ $SWAPQ = 'Y' ]
	then
		#setup swap to make sure there's enough memory for compiling the daemon 
		dd if=/dev/zero of=/mnt/myswap.swap bs=1M count=4000
		mkswap /mnt/myswap.swap
		chmod 0600 /mnt/myswap.swap
		swapon /mnt/myswap.swap
		echo "/mnt/myswap.swap    none    swap    sw    0   0" >> /etc/fstab
fi

echo "${RED}2. Do you like install dependencies and updates? (y) or (n) ${NONE}";
read DATAQ
if [ $DATAQ = 'y' ] || [ $DATAQ = 'Y' ]
	then
		#download and install required packages
		sudo apt-get update -y
		sudo apt-get upgrade -y
		sudo apt-get dist-upgrade -y
		sudo apt-get install git -y
		sudo apt-get install curl -y
		sudo apt-get install nano -y
		sudo apt-get install wget -y
		sudo apt-get install htop bc -y
		sudo apt-get install -y pwgen
		sudo apt-get install build-essential libtool automake autoconf -y
		sudo apt-get install autotools-dev autoconf pkg-config libssl-dev -y
		sudo apt-get install libgmp3-dev libevent-dev bsdmainutils libboost-all-dev -y
		sudo apt-get install libzmq3-dev -y
		sudo apt-get install libminiupnpc-dev -y
		sudo add-apt-repository ppa:bitcoin/bitcoin -y
		sudo apt-get update -y
		sudo apt-get install libdb4.8-dev libdb4.8++-dev -y
fi

#get Ketan client from github, compile the client
echo "${RED}3. How do you like install client? Download wallet from GitHub *Quicker, BUT use only of last wallet version is v1.0.0.1 (d) or Compiling wallet (c). (d) or (c) ${NONE}";
read INSTALLQ

cd $HOME
if [ $INSTALLQ = 'd' ] || [ $INSTALLQ = 'D' ]
	then
		sudo mkdir $HOME/wallet_ketan && cd wallet_ketan
		wget https://github.com/KetanScore/Ketan/releases/download/v1.0.0.1/Ketan-linux.tar.gz
		tar -xvf Ketan-linux.tar.gz && rm Ketan-linux.tar.gz
		chmod +x ketan* && mv ketan* /usr/local/bin && cd $HOME
		rm -r wallet_ketan
		#ketand --daemon
		#sleep 60
		#killall ketand
elif [ $INSTALLQ = 'c' ] || [ $INSTALLQ = 'C' ]
	then
		sudo mkdir $HOME/ketan
		git clone https://github.com/KetanScore/Ketan ketan
		cd $HOME/ketan
		chmod 777 autogen.sh
		./autogen.sh
		./configure --disable-tests --disable-gui-tests
		chmod 777 share/genbuild.sh
		sudo make
		sudo make install
		
fi
sudo mkdir $HOME/.ketan
echo "${GREEN}Installation completed. ${NONE}";

echo "${RED}Paste here your masternode key (right mouse click) and confirm with Enter ${NONE}";
read MNKEY

YOURIP=`wget -qO- ident.me`
PSS=`pwgen -1 20 -n`

echo "rpcuser=user"                   > /$HOME/.ketan/ketan.conf
echo "rpcpassword=$PSS"              >> /$HOME/.ketan/ketan.conf
echo "rpcallowip=127.0.0.1"          >> /$HOME/.ketan/ketan.conf
echo "maxconnections=500"            >> /$HOME/.ketan/ketan.conf
echo "daemon=0"                      >> /$HOME/.ketan/ketan.conf
echo "server=1"                      >> /$HOME/.ketan/ketan.conf
echo "listen=1"                      >> /$HOME/.ketan/ketan.conf
echo "logintimestamps=1"             >> /$HOME/.ketan/ketan.conf
echo "port=30012"                    >> /$HOME/.ketan/ketan.conf
echo "externalip=$YOURIP:30012"      >> /$HOME/.ketan/ketan.conf
echo "bind=$YOURIP"      			 >> /$HOME/.ketan/ketan.conf
echo "masternodeprivkey=$MNKEY"      >> /$HOME/.ketan/ketan.conf
echo "masternode=1"      			 >> /$HOME/.ketan/ketan.conf
echo "staking=1"                  	 >> /$HOME/.ketan/ketan.conf
echo ""                  			 >> /$HOME/.ketan/ketan.conf
echo "addnode=51.15.95.96:30012"     >> /$HOME/.ketan/ketan.conf
echo "addnode=80.211.93.98:30012"    >> /$HOME/.ketan/ketan.conf
echo "addnode=107.173.176.163:30012" >> /$HOME/.ketan/ketan.conf
echo "addnode=173.212.199.74:30012"  >> /$HOME/.ketan/ketan.conf
echo "addnode=95.179.166.251:30012"  >> /$HOME/.ketan/ketan.conf
echo "addnode=85.121.197.62:30012"   >> /$HOME/.ketan/ketan.conf
echo "addnode=64.110.129.134:30012"  >> /$HOME/.ketan/ketan.conf
echo "addnode=209.246.143.35:30012"  >> /$HOME/.ketan/ketan.conf
echo "addnode=217.69.12.168:30012"   >> /$HOME/.ketan/ketan.conf
echo "addnode=149.56.132.21:30012"   >> /$HOME/.ketan/ketan.conf
echo "addnode=149.28.232.37:30012"   >> /$HOME/.ketan/ketan.conf

ketand --daemon
sleep 30
echo "${RED}Waiting for your ketan client to fully sync with the network, this can take a while. ${NONE}";

block=1
while true
do
	realblock=`ketan-cli getblockcount` 
	explorerblock=`wget -qO- http://45.32.87.204:3001/api/getblockcount` #explorer API 
	percent=`echo "scale=2 ; (100*$realblock/$explorerblock)" | bc`
	printf "\rBlock: $realblock/$explorerblock - Done: ${GREEN}$percent%% ${NONE}" #write block
	if [ $realblock -eq $block ] #check block if is done
	then 
		sleep 60
		realblock=$((`ketan-cli getblockcount`))
		if [ $realblock -eq $block ] #second check block if is done
		then 
			echo ""
			break
		fi
	fi
	block=$((realblock))
	sleep 5	
done

echo "${RED}Blockchain sync start.${NONE}"
until ketan-cli mnsync status | grep -m 1 '"IsBlockchainSynced" : true'; do sleep 1 ; done > /dev/null 2>&1
echo "${GREEN}BlockchainSynced done. ${NONE}"

echo "${RED}Setting up your VPS is finish. You can now start MasterNode in your wallet. IF Masternode do not start in 30min then start it again.${NONE}"; 

echo "${RED}Waiting that MasterNode start.${NONE}"
until ketan-cli masternode status | grep -m 1 '"status" : "Masternode successfully started"'; do sleep 1 ; done > /dev/null 2>&1
echo "${GREEN}Done! Masternode successfully started, now you can close connection and wait until in your wallet will write ENABLED.${NONE}"

echo ""
echo "If this guild help you, then you can sent me some tips ;)"
echo "KETAN KFz6TjtVG3hAGt4Zjhh3L64DyGQtaYBsDH"
echo "BTC 12nxh3nUTJHve3XGaXrh692xQZMVLJLFJm"
echo "DOGE DJbHoCkzwzqjyrJxT1hGwN1rzZdJFzBseG"

sudo rm $HOME/ketanmn.sh