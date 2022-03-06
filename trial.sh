#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
MYIP=$(wget -qO- icanhazip.com);
echo "Script By JoySmart"
clear
IP=$(wget -qO- icanhazip.com);
ssl="$(cat ~/log-install.txt | grep -w "Stunnel4" | cut -d: -f2)"
sqd="$(cat ~/log-install.txt | grep -w "Squid" | cut -d: -f2)"
ovpn="$(netstat -nlpt | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
ovpn2="$(netstat -nlpu | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
Login=trial`</dev/urandom tr -dc X-Z0-9 | head -c4`
hari="1"
Pass=1
clear
useradd -e `date -d "$masaaktif days" +"%Y-%m-%d"` -s /bin/false -M $Login
exp="$(chage -l $Login | grep "Account expires" | awk -F": " '{print $2}')"
echo -e "$Pass\n$Pass\n"|passwd $Login &> /dev/null
echo -e ""
echo -e "==============================="
echo -e "ACCOUNT INFORMATION"
echo -e "==============================="
echo -e "HOST           : $IP"
echo -e "OPENSSH        : 22"
echo -e "DROPBEAR       : 109, 143"
echo -e "SSL/TLS        :$ssl"
echo -e "PORT SQUID     :$sqd"
echo -e "OPENVPN        : TCP $ovpn http://$IP:81/client-tcp.ovpn"
echo -e "OPENVPN        : UDP $ovpn2 http://$IP:81/client-udp.ovpn"
echo -e "OPENVPN        : SSL 442 http://$IP:81/client-tcp-ssl.ovpn"
echo -e "BADVPN         : 7100-7300"
echo -e "==============================="
echo -e ""
echo -e ""
echo -e "==============================="
echo -e "NIALVPN VVIP TRIAL"
echo -e "==============================="
echo -e "USERNAME       : $Login "
echo -e "PASSWORD       : $Pass"
echo -e "==============================="
echo -e "EXPIRED ON      : $exp"
echo -e "==============================="
echo -e "NIALSCRIPT"
