#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
MYIP=$(wget -qO- icanhazip.com);
echo "NIALSCRIPT"
clear
echo -e ""
echo -e "======================================"
echo -e "     [1]  Change Port Stunnel4"
echo -e "     [2]  Change Port OpenVPN"
echo -e "     [3]  Change Port Squid"
echo -e "     [x]  Exit"
echo -e "======================================"
echo -e ""
read -p "     Select From Options [1-3 or x] :  " port
echo -e ""
case $port in
1)
port-ssl
;;
2)
port-ovpn
;;
3)
port-squid
;;
x)
clear
menu
;;
*)
echo "Please enter an correct number"
;;
esac
