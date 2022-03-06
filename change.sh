#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
MYIP=$(wget -qO- icanhazip.com);
echo "NIALSCRIPT"
clear
echo -e ""
echo -e "======================================"
echo -e "     [1]  CHANGE PORT STUNNEL4"
echo -e "     [x]  Exit"
echo -e "======================================"
echo -e ""
read -p "     Select From Options [1 or x] :  " port
echo -e ""
case $port in
1)
sudo bash port-ssl.sh
;;
x)
clear
menu
;;
*)
echo "Please enter an correct number"
;;
esac
