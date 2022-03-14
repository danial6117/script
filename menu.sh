#!/bin/bash
clear
echo -e ""
echo -e " ==NIALVPN-SERVER==================="
echo -e ""
echo -e "==OPENVPN-SSH======================"
echo -e ""
echo -e "   1.NEW USER"  
echo -e "   2.TRIAL USER"  
echo -e "   3.HAPUS USER"      
echo -e ""
echo -e "==TROJAN-TCP======================="
echo -e ""
echo -e "   4.NEW USER" 
echo -e "   5.DELETE USER" 
echo -e "   6.START&CHANGE PORT" 
echo -e ""
echo -e "==ADD-ON==========================="
echo -e ""
echo -e "   7.INFO SERVER"                 
echo -e "   8.ALL USER MEMBER"        
echo -e "   9.ALL USER ONLINE"  
echo -e "   10.DNS CHANGER"   
echo -e "   11.BBR TWEAK"   
echo -e "   12.ZRAM TWEAK"   
echo -e "   13.AUTOREMOVE"   
echo -e "   14.REBOOT VPS "           
echo -e ""
echo -e "===================================="
echo -e ""
read -p "SELECT FROM OPTIONS [ 1 - 14 ] : " menu
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
tr-add
;;
5)
tr-del
;;
6)
trojan
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
nano /etc/resolv.conf
;;
11)
bbr
;;
12)
nano /usr/bin/init-zram-swapping
;;
13)
apt install autoremove
;;
14)
reboot
;;
*)
clear
menu
;;
esac
