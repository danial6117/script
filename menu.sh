#!/bin/bash
clear

echo -e ""
echo -e " ==NIALVPN-SERVER===================="
echo -e ""
echo -e "==OPENVPN-SSH======================"
echo -e ""
echo -e "   1.NEW USER"  
echo -e "   2.TRIAL USER"  
echo -e "   3.HAPUS USER"     
echo -e "   4.DELETE USER"               
echo -e ""
echo -e "==TROJAN-TCP========================"
echo -e ""
echo -e "   5.NEW USER" 
echo -e "   6.DELETE USER" 
echo -e ""
echo -e "==ADD-ON============================"
echo -e ""
echo -e "   7.INFO SERVER"                        
echo -e "   8.ALL USER MEMBER"        
echo -e "   9.ALL USER ONLINE"    
echo -e "   10.TCP&BBR TWEAK"    
echo -e "   11.SPEEDTEST VPS "            
echo -e "   12.REBOOT VPS "           
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
delete
;;
5)
tr-add
;;
6)
tr-del
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
speedtest
;;
12)
reboot
;;
*)
clear
menu
;;
esac
