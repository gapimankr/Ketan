# Ketan
Install shell script for Ketan Masternode
***
# Choose VPS provider  

- [Digital Ocean](https://m.do.co/c/d7dfd88a4484)
1. Get 10$ from this [link](https://m.do.co/c/d7dfd88a4484)
2. Use promo code CODEANYWHERE for extra 25$ free credit
3. Total 35$ for start (if you get some problems open ticket and they will help you)

- [Vultr](https://www.vultr.com/?ref=7465291)
1. Click on this [link](https://www.vultr.com/?ref=7465291) to confirm my referral link 
2. Use 25$ promo code [here](https://www.vultr.com/promo25b?service=promo25b) *promotion have limited time
***

## Installation

1. Create new VPS. Location is not important, for running server choose Linux Ubuntu 16.4.
2. Connect true SSH on VPS with PuTTY.
3. Paste this command line and installation will start.
```
wget https://raw.githubusercontent.com/gapimankr/Ketan/master/ketanmn.sh && chmod +x ketanmn.sh && sudo ./ketanmn.sh
``` 
4. Script will guide you step by step.
5. When will ask you for Masternode Kay look step 6 from Desktop wallet setup.

***

## Desktop wallet setup

After MN start installation on VPS or it just finish you need to configure the desktop wallet. 
1. Open Ketan wallet. If you do not have check [here](https://github.com/KetanScore/Ketan/releases)
2. Go to "**Receive**" and create new address. In to "**Label:**" write your mn label and click on "**Request payment**". Then copy address.
3. Go to "**Send**". In to "**Pay To:**" paste new address and in to "**Amount:**" write exactly 5000 KETAN and press "**Send**" 
4. Wait that payment will have complete confirmations.
5. Go to "**Tools**" -> "**Debug Console**" -> "**Console**"
6. Type the following command: "**masternode genkey**" and "**masternode outputs**"
7. Go to "**Tools**" -> "**Open Masternode Configuration File**"
8. Add the following entry:  
```
Alias Address Privkey TxHash TxIndex
```
* Alias: **MN1**
* Address: **VPS_IP:30012**
* Privkey: **Masternode Private Key from Step 6**
* TxHash: **First value from Step 6**
* TxIndex:  **Second value from Step 6**

```
Example:
MN1 127.0.0.2:30012 93HaYBVUCYjEMeeH1Y4sBGLALQZE1Yc1K64xiqgX37tGBDQL8Xg
2bcd3c84c84f87eaa86e4e56834c92927a07f9e18718810b92e0d0324456a67c 0
```
9. Save and close the file.
10. Go to "**Masternodes**". If you tab is not shown, please enable it from: "**Settings**" -> "**Options**" -> "**Wallet**" -> "**Show Masternodes Tab**"
11. Click "**Update status**" to see your node. If it is not shown, close the wallet and start it again.
12. Check PuTTY command line. If installation and synchronization is finish then script will tell you that you can start MN from wallet. 
	In this case click on "**MN1**" and "**Start alias**"(if this do not work start it from Debug Console with command line "**masternode start-alias MN1**"). 
	If all is correct you will get message that masternode successful start.
***

## Start on boot

If VPS restart, setup this self start up on reboot.
1. Login on VPS true PuTTY and paste "**crontab -e**" press 2(or other number). On the bottom paste "**@reboot /usr/local/bin/ketand**". Close and save with "**CTRL+X**" and "**Y**" and "**ENTER**". 

***

## Command lines

VPS server:
1. ketan-cli masternode status
2. ketan-cli getinfo
3. ketan-cli mnsync status
4. killall ketand *close all ketan daemon
5. nano .ketan/ketan.conf *Config file use it only of you know what are you doing.
6. ketand --daemon *Start Ketan Daemon 

***

## Donations 

If this guild help you, then you can sent me some tips ;)

**KETAN**: KFz6TjtVG3hAGt4Zjhh3L64DyGQtaYBsDH 
**BTC**: 12nxh3nUTJHve3XGaXrh692xQZMVLJLFJm  
**DOGE**: DJbHoCkzwzqjyrJxT1hGwN1rzZdJFzBseG
***
