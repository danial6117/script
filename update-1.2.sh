#!/bin/bash
if [ "${EUID}" -ne 0 ]; then
		echo "You need to run this script as root"
		exit 1
fi
if [ "$(systemd-detect-virt)" == "openvz" ]; then
		echo "OpenVZ is not supported"
		exit 1
fi
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
MYIP=$(wget -qO- icanhazip.com);
cd /usr/bin
wget -O menu "https://raw.githubusercontent.com/danial6117/script/main/menu.sh"
chmod +x menu
cd
echo "1.2" > /home/ver
clear
rm -f update.sh
