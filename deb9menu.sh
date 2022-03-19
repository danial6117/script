#!/bin/bash
clear
echo -e ""
echo -e " ==NIALVPN-SERVER==================="
echo -e ""
echo -e "==TROJAN-TCP======================="
echo -e ""
echo -e "   1.NEW USER" 
echo -e "   2.DELETE USER" 
echo -e "   3.START&CHANGE PORT" 
echo -e ""
echo -e "==ADD-ON==========================="
echo -e ""
echo -e "   4.DNS CHANGER"   
echo -e "   5.BBR TWEAK"   
echo -e "   6.AUTOREMOVE"   
echo -e "   7.REBOOT VPS "           
echo -e ""
echo -e "===================================="
echo -e ""
read -p "SELECT FROM OPTIONS [ 1 - 13 ] : " menu
echo -e ""
case $menu in
1)
tr-add
;;
2)
tr-del
;;
3)
trojan
;;
4)
nano /etc/resolv.conf
;;
5)
bbr
;;
6)
apt autoremove
;;
7)
reboot
;;
*)
clear
menu
;;
esac