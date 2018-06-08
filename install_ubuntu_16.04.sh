#!/bin/bash
#  ╔╗ ┬  ┌─┐┌─┐┬┌─┌┬┐┬ ┬┬─┐┌─┐┌─┐┬ ┬┌─┐┬─┐
#  ╠╩╗│  │ ││  ├┴┐ │ ├─┤├┬┘├─┤└─┐├─┤├┤ ├┬┘
#  ╚═╝┴─┘└─┘└─┘┴ ┴ ┴ ┴ ┴┴└─┴ ┴└─┘┴ ┴└─┘┴└─

clear

printf "\n╔╗ ┬  ┌─┐┌─┐┬┌─┌┬┐┬ ┬┬─┐┌─┐┌─┐┬ ┬┌─┐┬─┐  ╔═╗╔═╗╦═╗╦╦  ╦  ┬┌┐┌┌─┐┌┬┐┌─┐┬  ┬\n╠╩╗│  │ ││  ├┴┐ │ ├─┤├┬┘├─┤└─┐├─┤├┤ ├┬┘  ╚═╗║  ╠╦╝║╚╗╔╝  ││││└─┐ │ ├─┤│  │\n╚═╝┴─┘└─┘└─┘┴ ┴ ┴ ┴ ┴┴└─┴ ┴└─┘┴ ┴└─┘┴└─  ╚═╝╚═╝╩╚═╩ ╚╝   ┴┘└┘└─┘ ┴ ┴ ┴┴─┘┴─┘"

STRING1="Hello, and welcome to the automated SCRIV Masternode setup script (by Blockthrasher). Make sure you double check your entries before hitting enter! When asked Y/n for installs just hit the enter key."

STRING2="If you found this helpful, please donate SCRIV: "

STRING3="sgKLT7X271TQkfx3sGJgWHtE75Yv6AjyvM"

STRING4="Updating system and installing required packages."

STRING5="Switching to Aptitude"

STRING6="Some optional installs"

STRING7="Starting your masternode, please wait."

STRING8="Now, you need to connect and start your masternode in your local wallet:"

STRING9="It is best to do this after your VPS masternode has fully synced. It is currently at block:"

STRING10="To check again enter scriv-cli getblockcount. You can check this against explorer.scriv.network."

STRING11="Now, launch your local wallet. After launch and synchronization, go to the Masternodes tab. You will see your masternode with “MISSING” status. Right-click it and press Start alias -> Confirm by clicking Yes -> If everything is set up correctly, you will receive a “Successfully started masternode” message -> Hit “OK”."

STRING12="Well, that’s it. You are officially a Massternnode owner. Welcome to the SCRIV Masternode family."

STRING13=""

STRING14="If you found this helpful, please donate SCRIV: sgKLT7X271TQkfx3sGJgWHtE75Yv6AjyvM"

STRING14="Masternode Status:"

echo $STRING13
echo $STRING1

read -e -p "Server IP Address : " ip
read -e -p "Masternode Private Key (e.g. 7sTVNwqhWpjjFsyebseVT7K9KxBtwkd69V2exEmakqvLbv7TE9b # THE KEY YOU GENERATED EARLIER) : " key
read -e -p "Install Fail2ban? [Y/n] : " install_fail2ban
read -e -p "Install UFW and configure ports? [Y/n] : " UFW

clear
echo $STRING13
echo $STRING4
sleep 10

# update package and upgrade Ubuntu
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get dist-upgrade -y
sudo apt-get install nano htop git wget -y
sudo apt-get install unzip
sudo apt-get install build-essential libtool automake autoconf autogen libevent-dev pkg-config
sudo apt-get install autotools-dev autoconf pkg-config libssl-dev
sudo apt-get install libssl-dev libevent-dev bsdmainutils software-properties-common -y
sudo apt-get install libgmp3-dev libevent-dev bsdmainutils libboost-all-dev
sudo add-apt-repository ppa:bitcoin/bitcoin
sudo apt-get update
sudo apt-get install libdb4.8-dev libdb4.8++-dev
sudo apt-get install libminiupnpc-dev
clear
echo $STRING5
sudo apt-get -y install aptitude

#Generating Random Passwords
password=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
password2=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

echo $STRING6
if [[ ("$install_fail2ban" == "y" || "$install_fail2ban" == "Y" || "$install_fail2ban" == "") ]]; then
  cd ~
  sudo aptitude -y install fail2ban
  sudo service fail2ban restart
fi
if [[ ("$UFW" == "y" || "$UFW" == "Y" || "$UFW" == "") ]]; then
  sudo apt-get install ufw
  sudo ufw default deny incoming
  sudo ufw default allow outgoing
  sudo ufw allow ssh
  sudo ufw allow openssh
  sudo ufw allow ssh/tcp
  sudo ufw limit ssh/tcp
  sudo ufw allow 7998/tcp
  sudo ufw allow 7979/tcp
  sudo ufw enable -y
fi

#Install SCRIV Daemon
wget https://github.com/ScrivNetwork/scriv/releases/download/1.1.0/Scriv-Linux-x86-1.1.0.0.zip
sudo unzip Scriv-Linux-x86-1.1.0.0.zip -d scriv
sudo rm Scriv-Linux-x86-1.1.0.0.zip
sudo chmod 755 scriv/scrivd 
sudo chmod 755 scriv/scriv-cli 
sudo chmod 755 scriv/scriv-tx
sudo cp scriv/scrivd /usr/bin
sudo cp scriv/scriv-cli /usr/bin
scrivd -daemon
clear

#Setting up coin
echo $STRING13
echo $STRING4
killall scrivd
clear
#sleep 10

#Create scriv.conf
echo '
rpcallowip=127.0.0.1
rpcuser='$password'
rpcpassword='$password2'
server=1
listen=1
externalip='$ip'
bind='$ip':7979
masternodeaddr='$ip'
masternodeprivkey='$key'
masternode=1
' | sudo -E tee ~/.scrivcore/scriv.conf >/dev/null 2>&1
sudo chmod 0600 ~/.scrivcore/scriv.conf

#Starting coin
(
  crontab -l 2>/dev/null
  echo '@reboot sleep 30 && scrivd -shrinkdebugfile'
) | crontab
scrivd -daemon

clear
echo $STRING7
sleep 20
echo $STRING15
scriv-cli masternode status
echo $STRING13
echo $STRING8
echo $STRING13
echo $STRING9
scriv-cli getblockcount
echo $STRING13
echo $STRING10
echo $STRING13
echo $STRING11
echo $STRING13
echo $STRING12
echo $STRING14


