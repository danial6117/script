#!/bin/bash
cd /usr/bin
apt update && apt upgrade -y
apt install tweak -y
apt install resolvconf 
apt install net-tools
apt install snapd
snap install hello-world
apt install android-tools-adb -y
apt install android-tools-fastboot -y
adb start-server
apt install earlyoom
apt install util-linux 
apt install zram-config 
apt-get autoremove -y
apt-get autoclean -y
apt-get install localpurge -y

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

# set time GMT +8
ln -fs /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
systemctl restart ssh

# iptables
iptables -t nat -I POSTROUTING -s 10.8.0.0/24 -o $ANU -j MASQUERADE
iptables -t nat -I POSTROUTING -s 10.9.0.0/24 -o $ANU -j MASQUERADE

sed -i '$ i\iptables -t nat -I POSTROUTING -s 10.8.0.0/24 -o xxx -j MASQUERADE' /etc/rc.local
sed -i '$ i\iptables -t nat -I POSTROUTING -s 10.9.0.0/24 -o xxx -j MASQUERADE' /etc/rc.local

sed -i $APA /etc/rc.local

# install
apt-get --reinstall --fix-missing install -y bzip2 gzip coreutils wget screen rsyslog iftop htop net-tools zip unzip wget net-tools curl nano sed screen gnupg gnupg1 bc apt-transport-https build-essential dirmngr libxml-parser-perl neofetch git lsof
echo "clear" >> .profile
echo "neofetch" >> .profile

# go to root
cd

# download script
cd /usr/bin
wget -O menu "https://raw.githubusercontent.com/danial6117/script/main/menu2"
wget -O swapkvm "https://raw.githubusercontent.com/danial6117/script/main/swapkvm.sh"
wget -O trojan "https://script.gegevps.com/freescript.sh"
wget -O bbr "https://raw.githubusercontent.com/ylx2016/Linux-NetSpeed/master/tcp.sh"

# set script permission
chmod +x menu 
chmod +x swapkvm
chmod +x trojan
chmod +x bbr

# info
clear
echo " "
echo "Installation has been completed!!"
echo "==========-Autoscript Premium-====================" | tee -a log-install.txt
echo ">>> Service & Port"  | tee -a log-install.txt
echo "- trojan        : 443"  | tee -a log-install.txt
echo "- Fail2Ban      : [ON]"  | tee -a log-install.txt
echo "- Dflate        : [ON]"  | tee -a log-install.txt
echo "- IPtables      : [ON]"  | tee -a log-install.txt
echo "- IPv6          : [OFF]"  | tee -a log-install.txt
echo "- Installation Log --> /root/log-install.txt"  | tee -a log-install.txt
echo "=================================================" | tee -a log-install.txt
echo " PLEASE REBOOT"
