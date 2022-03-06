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
wget -O usernew "https://raw.githubusercontent.com/danial6117/script/main/usernew.sh"
wget -O trial "https://raw.githubusercontent.com/danial6117/script/main/trial.sh"
wget -O hapus "https://raw.githubusercontent.com/danial6117/script/main/hapus.sh"
wget -O info "https://raw.githubusercontent.com/danial6117/script/main/info.sh"
wget -O about "https://raw.githubusercontent.com/danial6117/script/main/about.sh"
wget -O port-ssl "https://github.com/danial6117/script/blob/main/port-ssl.sh"
wget -O change "https://raw.githubusercontent.com/danial6117/script/main/change.sh"
chmod +x menu
chmod +x usernew
chmod +x trial
chmod +x hapus
chmod +x info
chmod +x about
chmod +x port-ssl
chmod +x change
cd
echo "1.2" > /home/ver
clear
rm -f update.sh
