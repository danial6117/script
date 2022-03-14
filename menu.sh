#!/bin/bash
clear

echo -e ""
echo -e " ==NIALVPN-SERVER===================="
echo -e ""
echo -e "==OPENVPN-SSH======================"
echo -e ""
echo -e "  1.NEW USER"  
echo -e "  2.TRIAL USER"  
echo -e "  3.HAPUS USER"                
echo -e ""
echo -e "==TROJAN-TCP========================"
echo -e ""
echo -e "  4.NEW USER" 
echo -e "  5.DELETE USER" 
echo -e "  6.START/CHANGE PORT" 
echo -e ""
echo -e "==ADD-ON============================"
echo -e ""
echo -e "  7.INFO SERVER"                     
echo -e "  8.ALL USER MEMBER"     
echo -e "  9.ALL USER ONLINE"
echo -e " 10.TCP&BBR TWEAK" 
echo -e " 11.ZRAM TWEAK"  
echo -e " 12.DNS CHANGER"   
echo -e " 13.REBOOT VPS "           
echo -e ""
echo -e "====================================="
read -p "SELECT FROM [ 1 - 13 ] : " menu
case $menu in
1)
usernew
;;
2)
trial
;;
3)
hapus
;;
4)
tr-add
;;
5)
tr-del
;;
6)
./freescript.sh
;;
7)
info
;;
8)
member
;;
9)
cek
;;
10)
./tcp.sh
;;
11)
nano /usr/bin/init-zram-swapping
;;
12)
nano /etc/resolv.conf
;;
13)
reboot
;;
*)
clear
menu
;;
esac
