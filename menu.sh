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
echo -e "   8.CHANGE PORT"                         
echo -e "   9.ALL USER MEMBER"        
echo -e "   10.ALL USER ONLINE"    
echo -e "   11.TCP&BBR TWEAK"    
echo -e "   12.SPEEDTEST VPS "            
echo -e "   13.REBOOT VPS "           
echo -e ""
echo -e "====================================="
echo -e ""
read -p "SELECT FROM OPTIONS [ 1 - 13 ] : " menu
echo -e ""
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

;;
8)
change
;;
9)
member
;;
10)
cek
;;
11)
./tcp.sh
;;
12)
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