#!/bin/bash
# variable initialization
export DEBIAN_FRONTEND=noninteractive
MYIP=$(wget -qO- ipv4.icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";
source="http://evira.us/ubuntu20"
GROUPNAME=nogroup
ANU=$(ip -o -4 route show to default | awk '{print $5}')
APA="s/xxx/$ANU/g"
CLIENT=client

# company name details
country=MY
state=Kuala_Lumpur
locality=Kuala_Lumpur
organization=NIALSCRIPT
organizationalunit=IT
commonname=NIALVPN

# go to root
cd

# fix rc.local problem
cat > /etc/systemd/system/rc-local.service <<-END
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local

[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99

[Install]
WantedBy=multi-user.target
END

cat > /etc/rc.local <<-END
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.

exit 0
END

chmod +x /etc/rc.local
systemctl enable rc-local
systemctl start rc-local.service


# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

# set time GMT +8
ln -fs /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
systemctl restart ssh

apt-get update
apt-get -y install apt-transport-https gnupg1

# update
apt-get update

# install apps
apt-get -y install wget curl nano iptables dnsutils screen dropbear squid3 stunnel4 openvpn neofetch openssl ca-certificates nginx python

# setting welcome screen
echo "clear" >> .profile
echo 'echo -e ""' >> .profile
echo 'echo -e " SELAMAT DATANG \e[031;1m$HOSTNAME\e[0m"' >> .profile
echo 'echo -e " SCRIPT MOD BY NIALVPN"' >> .profile
echo 'echo -e " Taip \e[031;1mmenu\e[0m UNTUK MEMBUAT VPN"' >> .profile
echo 'echo -e ""' >> .profile

# setting port ssh
sed -i 's/#Port 22/Port 22/g' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 444' /etc/ssh/sshd_config
systemctl restart ssh

# setting dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=143/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 82"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
systemctl restart ssh
systemctl restart dropbear

# setting webmin
sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf
systemctl restart webmin

# setting squid3
wget -O /etc/squid/squid.conf "$source/squid.conf"
sed -i $MYIP2 /etc/squid/squid.conf;
systemctl restart squid

# setting stunnel
cat > /etc/stunnel/stunnel.conf <<-END
cert = /etc/stunnel/stunnel.pem
client = no
socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1


[dropbear]
accept = 443
connect = 127.0.0.1:82
END

# make a certificate
openssl genrsa -out key.pem 2048
openssl req -new -x509 -key key.pem -out cert.pem -days 1095 \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
cat key.pem cert.pem >> /etc/stunnel/stunnel.pem

# stunnel configuration
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
systemctl restart stunnel4

# install badvpn
cd
wget -O /usr/bin/badvpn-udpgw "$source/badvpn-udpgw64"
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200' /etc/rc.local
chmod +x /usr/bin/badvpn-udpgw
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200

# setting vnstat
# vnstat -u -i $ANU
# systemctl restart vnstat

# nginx configuration
rm /etc/nginx/sites-enabled/default
wget -O /etc/nginx/sites-enabled/default "$source/default"
systemctl restart nginx

# setting openvpn
# get easy-rsa
EASYRSAURL='https://github.com/OpenVPN/easy-rsa/releases/download/v3.0.5/EasyRSA-nix-3.0.5.tgz'
wget -O ~/easyrsa.tgz "$EASYRSAURL" 2>/dev/null || curl -Lo ~/easyrsa.tgz "$EASYRSAURL"
tar xzf ~/easyrsa.tgz -C ~/
mv ~/EasyRSA-3.0.5/ /etc/openvpn/
mv /etc/openvpn/EasyRSA-3.0.5/ /etc/openvpn/easy-rsa/
chown -R root:root /etc/openvpn/easy-rsa/
rm -f ~/easyrsa.tgz
cd /etc/openvpn/easy-rsa/

# create the PKI, set up the CA and the server and client certificates
./easyrsa init-pki
./easyrsa --batch build-ca nopass
EASYRSA_CERT_EXPIRE=3650 ./easyrsa build-server-full server nopass
EASYRSA_CERT_EXPIRE=3650 ./easyrsa build-client-full $CLIENT nopass
EASYRSA_CRL_DAYS=3650 ./easyrsa gen-crl

# move the stuff we need
cp pki/ca.crt pki/private/ca.key pki/issued/server.crt pki/private/server.key pki/crl.pem /etc/openvpn

# CRL is read with each client connection, when OpenVPN is dropped to nobody
chown nobody:$GROUPNAME /etc/openvpn/crl.pem

# generate key for tls-auth
openvpn --genkey --secret /etc/openvpn/ta.key

# create the DH parameters file using the predefined ffdhe2048 group
cat > /etc/openvpn/dh.pem <<-END
-----BEGIN DH PARAMETERS-----
MIIBCAKCAQEA//////////+t+FRYortKmq/cViAnPTzx2LnFg84tNpWp4TZBFGQz
+8yTnc4kmz75fS/jY2MMddj2gbICrsRhetPfHtXV/WVhJDP1H18GbtCFY2VVPe0a
87VXE15/V8k1mE8McODmi3fipona8+/och3xWKE2rec1MKzKT0g6eXq8CrGCsyT7
YdEIqUuyyOP7uWrat2DX9GgdT0Kj3jlN9K5W7edjcrsZCwenyO4KbXCeAvzhzffi
7MA0BM0oNC9hkXL+nOmFg/+OTxIy7vKBg8P+OxtMb61zO7X8vC7CIAXFjvGDfRaD
ssbzSibBsu/6iGtCOGEoXJf//////////wIBAg==
-----END DH PARAMETERS-----
END

# generate server-tcp.conf
cat > /etc/openvpn/server-tcp.conf <<-END
port 1194
proto tcp
dev tun
ca ca.crt
cert server.crt
key server.key
dh dh.pem
verify-client-cert none
username-as-common-name
plugin /usr/lib/x86_64-linux-gnu/openvpn/plugins/openvpn-plugin-auth-pam.so login
server 10.8.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 1.1.1.1"
push "dhcp-option DNS 1.0.0.1"
push "route-method exe"
push "route-delay 2"
socket-flags TCP_NODELAY
push "socket-flags TCP_NODELAY"
keepalive 10 120
comp-lzo
duplicate-cn
group nogroup
persist-key
persist-tun
status openvpn-status.log
log openvpn.log
verb 3
ncp-disable
cipher none
auth none
END

# generate server-udp.conf
cat > /etc/openvpn/server-udp.conf <<-END
port 25000
proto udp
dev tun
ca ca.crt
cert server.crt
key server.key
dh dh.pem
verify-client-cert none
username-as-common-name
plugin /usr/lib/x86_64-linux-gnu/openvpn/plugins/openvpn-plugin-auth-pam.so login
server 10.9.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 1.1.1.1"
push "dhcp-option DNS 1.0.0.1"
push "route-method exe"
push "route-delay 2"
socket-flags TCP_NODELAY
push "socket-flags TCP_NODELAY"
keepalive 10 120
comp-lzo
duplicate-cn
group nogroup
persist-key
persist-tun
status openvpn-status.log
log openvpn.log
verb 3
ncp-disable
cipher none
auth none
END

# enable net.ipv4.ip_forward for the system
echo 'net.ipv4.ip_forward=1' > /etc/sysctl.d/30-openvpn-forward.conf

# enable without waiting for a reboot or service restart
echo 1 > /proc/sys/net/ipv4/ip_forward

# iptables
iptables -t nat -I POSTROUTING -s 10.8.0.0/24 -o $ANU -j MASQUERADE
iptables -t nat -I POSTROUTING -s 10.9.0.0/24 -o $ANU -j MASQUERADE

sed -i '$ i\iptables -t nat -I POSTROUTING -s 10.8.0.0/24 -o xxx -j MASQUERADE' /etc/rc.local
sed -i '$ i\iptables -t nat -I POSTROUTING -s 10.9.0.0/24 -o xxx -j MASQUERADE' /etc/rc.local

sed -i $APA /etc/rc.local

# start & enable OpenVPN server.conf
systemctl start openvpn@server-tcp
systemctl enable openvpn@server-tcp
systemctl start openvpn@server-udp
systemctl enable openvpn@server-udp

# generates client-tcp.ovpn
cat > /var/www/html/client-tcp.ovpn <<-END
auth-user-pass
client
dev tun
proto tcp
setenv FRIENDLY_NAME "NIALVPN VVIP"
remote xxxxxxxxx 1194
http-proxy xxxxxxxxx 8080
persist-key
persist-tun
pull
resolv-retry infinite
nobind
comp-lzo
duplicate-cn
remote-cert-tls server
verb 3
mute 2
connect-retry 5 5
connect-retry-max 8080
mute-replay-warnings
redirect-gateway def1
script-security 2
cipher none
auth none
END

echo "<ca>" >> /var/www/html/client-tcp.ovpn
cat /etc/openvpn/easy-rsa/pki/ca.crt >> /var/www/html/client-tcp.ovpn
echo "</ca>" >> /var/www/html/client-tcp.ovpn
sed -i $MYIP2 /var/www/html/client-tcp.ovpn;

# generates client-udp.ovpn
cat > /var/www/html/client-udp.ovpn <<-END
auth-user-pass
client
dev tun
proto udp
setenv FRIENDLY_NAME "NIALVPN VVIP"
remote xxxxxxxxx 25000
persist-key
persist-tun
pull
resolv-retry infinite
nobind
comp-lzo
duplicate-cn
remote-cert-tls server
verb 3
mute 2
connect-retry 5 5
connect-retry-max 8080
mute-replay-warnings
redirect-gateway def1
script-security 2
cipher none
auth none
END

echo "<ca>" >> /var/www/html/client-udp.ovpn
cat /etc/openvpn/easy-rsa/pki/ca.crt >> /var/www/html/client-udp.ovpn
echo "</ca>" >> /var/www/html/client-udp.ovpn
sed -i $MYIP2 /var/www/html/client-udp.ovpn;

# go to root
cd

# download script
cd /usr/bin
wget -O menu "https://raw.githubusercontent.com/danial6117/script/main/menu.sh"
wget -O usernew "https://raw.githubusercontent.com/danial6117/script/main/usernew.sh"
wget -O trial "https://raw.githubusercontent.com/danial6117/script/main/trial.sh"
wget -O hapus "https://raw.githubusercontent.com/danial6117/script/main/hapus.sh"
wget -O cek "$source/user-login.sh"
wget -O member "$source/user-list.sh"
wget -O info "https://raw.githubusercontent.com/danial6117/script/main/info.sh"
wget -O about "https://raw.githubusercontent.com/danial6117/script/main/about.sh"

# set script permission
chmod +x menu usernew trial hapus cek member info about

# fix password
cd
wget -O /etc/pam.d/common-password "$source/common-password"

# setting auto reboot
echo "0 0 * * * root reboot" >> /etc/crontab

# info
clear
echo " "
echo "Installation has been completed!!"
echo " "
echo "=================================-Autoscript Premium-===========================" | tee -a log-install.txt
echo "" | tee -a log-install.txt
echo "--------------------------------------------------------------------------------" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   >>> Service & Port"  | tee -a log-install.txt
echo "   - OpenSSH                 : 22"  | tee -a log-install.txt
echo "   - OpenVPN                 : TCP 1194, UDP 2200, SSL 442"  | tee -a log-install.txt
echo "   - Stunnel4                : 443, 777"  | tee -a log-install.txt
echo "   - Dropbear                : 109, 143"  | tee -a log-install.txt
echo "   - Squid Proxy             : 3128, 8080 (limit to IP Server)"  | tee -a log-install.txt
echo "   - Badvpn                  : 7100, 7200, 7300"  | tee -a log-install.txt
echo "   - Nginx                   : 81"  | tee -a log-install.txt
echo "   - XRAYS Vmess TLS         : 8443"  | tee -a log-install.txt
echo "   - XRAYS Vmess None TLS    : 80"  | tee -a log-install.txt
echo "   - XRAYS Vless TLS         : 8443"  | tee -a log-install.txt
echo "   - XRAYS Vless None TLS    : 80"  | tee -a log-install.txt
echo "   - XRAYS Trojan            : 2083"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   >>> Server Information & Other Features"  | tee -a log-install.txt
echo "   - Timezone                : Asia/Jakarta (GMT +7)"  | tee -a log-install.txt
echo "   - Fail2Ban                : [ON]"  | tee -a log-install.txt
echo "   - Dflate                  : [ON]"  | tee -a log-install.txt
echo "   - IPtables                : [ON]"  | tee -a log-install.txt
echo "   - Auto-Reboot             : [ON]"  | tee -a log-install.txt
echo "   - IPv6                    : [OFF]"  | tee -a log-install.txt
echo "   - Autoreboot On 05.00 GMT +7" | tee -a log-install.txt
echo "   - Autobackup Data" | tee -a log-install.txt
echo "   - Restore Data" | tee -a log-install.txt
echo "   - Auto Delete Expired Account" | tee -a log-install.txt
echo "   - Full Orders For Various Services" | tee -a log-install.txt
echo "   - White Label" | tee -a log-install.txt
echo "   - Installation Log --> /root/log-install.txt"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   - Dev/Main                : NIALCSCRIPT"  | tee -a log-install.txt
echo "   - Telegram                : t.me/nialVPN"  | tee -a log-install.txt
echo "------------------Script Created By NIALSCRIPT-----------------" | tee -a log-install.txt
echo ""
echo " Reboot 15 Sec"
rm -f /root/nialscript.sh /root/cert.pem /root/jcameron-key.asc /root/key.pem�������
sleep 15
reboot
