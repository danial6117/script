#!/bin/bash
clear

echo -e ""
echo -e " ==NIALVPN-SERVER===================="
echo -e ""
echo -e "==OPENVPN-SSH======================"
echo -e ""
echo -e "1.NEW USER"  
echo -e "2.TRIAL USER"  
echo -e "3.HAPUS USER"                
echo -e ""
echo -e "==TROJAN-TCP========================"
echo -e ""
echo -e "4.NEW USER" 
echo -e "5.DELETE USER" 
echo -e ""
echo -e "==ADD-ON============================"
echo -e ""
echo -e "6.INFO SERVER"                        
echo -e "7.ALL USER MEMBER"        
echo -e "8.ALL USER ONLINE"    
echo -e "9.TCP&BBR TWEAK"              
echo -e "10.REBOOT VPS "           
echo -e ""
echo -e "====================================="
read -p "SELECT FROM OPTIONS [ 1 - 12 ] : " menu
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
info
;;
7)
member
;;
8)
cek
;;
9)
./tcp.sh
;;
10)
reboot
;;
*)
clear
menu
;;
esac
