#!/bin/bash
# By IanVPN
#
# ==================================================

# initializing var
export DEBIAN_FRONTEND=noninteractive
MYIP=$(wget -qO- ipinfo.io/ip);
MYIP2="s/xxxxxxxxx/$MYIP/g";
NET=$(ip -o $ANU -4 route show to default | awk '{print $5}');
source /etc/os-release
ver=$VERSION_ID
domain=$(cat /root/domain)
#detail nama perusahaan
country=MY
state=Malaysia
locality=Malaysia
organization=www.ianvpn.xyz
organizationalunit=www.ianvpn.xyz
commonname=www.ianvpn.xyz
email=admin@IanVPN.xyz

# simple password minimal
wget -O /etc/pam.d/common-password "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/password"
chmod +x /etc/pam.d/common-password

# go to root
cd

# Edit file /etc/systemd/system/rc-local.service
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

# nano /etc/rc.local
cat > /etc/rc.local <<-END
#!/bin/sh -e
# rc.local
# By default this script does nothing.
exit 0
END

# Ubah izin akses
chmod +x /etc/rc.local

# enable rc local
systemctl enable rc-local
systemctl start rc-local.service

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

#update
apt update -y
apt upgrade -y
apt dist-upgrade -y
apt-get remove --purge ufw firewalld -y
apt-get remove --purge exim4 -y

# install wget and curl
apt -y install wget curl

# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config

# install
apt-get --reinstall --fix-missing install -y linux-headers-cloud-amd64 bzip2 gzip coreutils wget jq screen rsyslog iftop htop net-tools zip unzip wget net-tools curl nano sed screen gnupg gnupg1 bc apt-transport-https build-essential dirmngr libxml-parser-perl git lsof
cat> /root/.profile << END
# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

mesg n || true
clear
menu
END
chmod 644 /root/.profile

# install NGINX webserver
sudo apt install gnupg2 ca-certificates lsb-release -y 
echo "deb http://nginx.org/packages/mainline/debian $(lsb_release -cs) nginx" | sudo tee /etc/apt/sources.list.d/nginx.list 
echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" | sudo tee /etc/apt/preferences.d/99nginx 
curl -o /tmp/nginx_signing.key https://nginx.org/keys/nginx_signing.key 
# gpg --dry-run --quiet --import --import-options import-show /tmp/nginx_signing.key
sudo mv /tmp/nginx_signing.key /etc/apt/trusted.gpg.d/nginx_signing.asc
sudo apt update 
apt -y install nginx 
systemctl daemon-reload
systemctl enable nginx
touch /etc/nginx/conf.d/alone.conf
cat <<EOF >>/etc/nginx/conf.d/alone.conf
server {
	listen 81;
	listen [::]:81;
	server_name ${domain};
	# shellcheck disable=SC2154
	return 301 https://${domain};
}
server {
		listen 127.0.0.1:31300;
		server_name _;
		return 403;
}
server {
	listen 127.0.0.1:31302 http2;
	server_name ${domain};
	root /usr/share/nginx/html;
	location /s/ {
    		add_header Content-Type text/plain;
    		alias /etc/rare/config-url/;
    }

    location /xraygrpc {
		client_max_body_size 0;
#		keepalive_time 1071906480m;
		keepalive_requests 4294967296;
		client_body_timeout 1071906480m;
 		send_timeout 1071906480m;
 		lingering_close always;
 		grpc_read_timeout 1071906480m;
 		grpc_send_timeout 1071906480m;
		grpc_pass grpc://127.0.0.1:31301;
	}

	location /xraytrojangrpc {
		client_max_body_size 0;
		# keepalive_time 1071906480m;
		keepalive_requests 4294967296;
		client_body_timeout 1071906480m;
 		send_timeout 1071906480m;
 		lingering_close always;
 		grpc_read_timeout 1071906480m;
 		grpc_send_timeout 1071906480m;
		grpc_pass grpc://127.0.0.1:31304;
	}
}
server {
	listen 127.0.0.1:31300;
	server_name ${domain};
	root /usr/share/nginx/html;
	location /s/ {
		add_header Content-Type text/plain;
		alias /etc/rare/config-url/;
	}
	location / {
		add_header Strict-Transport-Security "max-age=15552000; preload" always;
	}
}
EOF
mkdir /etc/systemd/system/nginx.service.d
printf "[Service]\nExecStartPost=/bin/sleep 0.1\n" > /etc/systemd/system/nginx.service.d/override.conf
rm /etc/nginx/conf.d/default.conf
systemctl daemon-reload
service nginx restart
cd
rm -rf /usr/share/nginx/html
wget -q -P /usr/share/nginx https://raw.githubusercontent.com/racunzx/hijk.art/main/html.zip 
unzip -o /usr/share/nginx/html.zip -d /usr/share/nginx/html 
rm -f /usr/share/nginx/html.zip*

# install badvpn
cd
wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/badvpn-udpgw64"
chmod +x /usr/bin/badvpn-udpgw
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500' /etc/rc.local
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500

# setting port ssh
sed -i 's/Port 22/Port 22/g' /etc/ssh/sshd_config

# install dropbear
apt -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=143/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 109"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
/etc/init.d/dropbear restart

# install squid
cd
apt -y install squid3
wget -O /etc/squid/squid.conf "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/squid3.conf"
sed -i $MYIP2 /etc/squid/squid.conf

# setting vnstat
apt -y install vnstat
/etc/init.d/vnstat restart
apt -y install libsqlite3-dev
wget https://humdi.net/vnstat/vnstat-2.6.tar.gz
tar zxvf vnstat-2.6.tar.gz
cd vnstat-2.6
./configure --prefix=/usr --sysconfdir=/etc && make && make install
cd
vnstat -u -i $NET
sed -i 's/Interface "'""eth0""'"/Interface "'""$NET""'"/g' /etc/vnstat.conf
chown vnstat:vnstat /var/lib/vnstat -R
systemctl enable vnstat
/etc/init.d/vnstat restart
rm -f /root/vnstat-2.6.tar.gz
rm -rf /root/vnstat-2.6

# install stunnel
apt install stunnel4 -y
cat > /etc/stunnel/stunnel.conf <<-END
cert = /etc/stunnel/stunnel.pem
client = no
socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1

[dropbear]
accept = 444
connect = 127.0.0.1:109

[dropbear]
accept = 777
connect = 127.0.0.1:22

END

# make a certificate
openssl genrsa -out key.pem 2048
openssl req -new -x509 -key key.pem -out cert.pem -days 1095 \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
cat key.pem cert.pem >> /etc/stunnel/stunnel.pem

# konfigurasi stunnel
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
/etc/init.d/stunnel4 restart

#OpenVPN
wget https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/vpn.sh &&  chmod +x vpn.sh && ./vpn.sh

# install fail2ban
apt -y install fail2ban

# Instal DDOS Flate
if [ -d '/usr/local/ddos' ]; then
	echo; echo; echo "Please un-install the previous version first"
	exit 0
else
	mkdir /usr/local/ddos
fi
clear
echo; echo 'Installing DOS-Deflate 0.6'; echo
echo; echo -n 'Downloading source files...'
apt install -y dnsutils tcpdump dsniff grepcidr
wget -qO ddos.zip "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/ddos-deflate.zip"
unzip ddos.zip
cd ddos-deflate
chmod +x install.sh
./install.sh
cd
rm -rf ddos.zip ddos-deflate
echo '...done'
echo; echo 'Installation has completed.'
echo 'Config file is at /usr/local/ddos/ddos.conf'
echo 'Please send in your comments and/or suggestions to zaf@vsnl.com'

# banner /etc/issue.net
wget -O /etc/issue.net "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/banner.conf"
echo "Banner /etc/issue.net" >>/etc/ssh/sshd_config
sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/issue.net"@g' /etc/default/dropbear

# blockir torrent
iptables -A FORWARD -m string --string "get_peers" --algo bm -j DROP
iptables -A FORWARD -m string --string "announce_peer" --algo bm -j DROP
iptables -A FORWARD -m string --string "find_node" --algo bm -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -A FORWARD -m string --algo bm --string "peer_id=" -j DROP
iptables -A FORWARD -m string --algo bm --string ".torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce.php?passkey=" -j DROP
iptables -A FORWARD -m string --algo bm --string "torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce" -j DROP
iptables -A FORWARD -m string --algo bm --string "info_hash" -j DROP
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload

# download script
cd /usr/bin
# menu
wget -O menu "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/menu.sh"
# menu ssh-ovpn
wget -O m-sshovpn "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/m-sshovpn.sh"
wget -O usernew "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/usernew.sh"
wget -O trial "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/trial.sh"
wget -O renew "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/renew.sh"
wget -O hapus "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/hapus.sh"
wget -O cek "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/cek.sh"
wget -O member "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/member.sh"
wget -O delete "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/delete.sh"
wget -O autokill "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/autokill.sh"
wget -O ceklim "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/ceklim.sh"
wget -O tendang "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/tendang.sh"
# menu wg
cd /usr/bin
wget -O m-wg "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/m-wg.sh"
# menu ssr
wget -O m-ss "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/m-ss.sh"
# menu trojan
wget -O m-trojan "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/m-trojan.sh"
# menu system
wget -O m-system "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/m-system.sh"
wget -O m-domain "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/m-domain.sh"
wget -O add-host "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/add-host.sh"
wget -O cff "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/cff.sh"
wget -O cfd "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/cfd.sh"
wget -O cfh "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/cfh.sh"
wget -O certv2ray "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/certv2ray.sh"
wget -O port-change "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/port-change.sh"
   # change port
wget -O port-ssl "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/port-ssl.sh"
wget -O port-ovpn "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/port-ovpn.sh"
wget -O port-wg "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/port-wg.sh"
wget -O port-tr "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/port-tr.sh"
wget -O port-squid "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/port-squid.sh"
# menu system
wget -O m-webmin "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/m-webmin.sh"
wget -O ram "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/ram.sh"
wget -O speedtest "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/speedtest_cli.py"
wget -O info-menu "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/info-menu.sh"
wget -O vpsinfo "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/vpsinfo.sh"
wget -O status "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/status.sh"
wget -O about "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/about.sh"
wget -O bbr "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/bbr.sh"
wget -O auto-reboot "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/auto-reboot.sh"
wget -O clear-log "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/clear-log.sh"
wget -O clearcache "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/clearcache.sh"
wget -O restart "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/restart.sh"
wget -O bw "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/bw.sh"
wget -O resett "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/resett.sh"
wget -O kernel-updt "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/kernel-updt.sh"
#xpired
wget -O xp "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/xp.sh"
wget -O xray-xp "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/xray-xp.sh"
wget -O v2ray-xp "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/v2ray-xp.sh"

chmod +x menu
chmod +x m-sshovpn
chmod +x usernew
chmod +x trial
chmod +x renew
chmod +x hapus
chmod +x cek
chmod +x member
chmod +x delete
chmod +x autokill
chmod +x ceklim
chmod +x tendang
chmod +x m-wg
chmod +x m-ss
chmod +x m-trojan
chmod +x m-system
chmod +x m-domain
chmod +x add-host
chmod +x cff
chmod +x cfd
chmod +x cfh
chmod +x certv2ray
chmod +x port-change
chmod +x port-ssl
chmod +x port-ovpn
chmod +x port-wg
chmod +x port-tr
chmod +x port-squid
chmod +x m-webmin
chmod +x ram
chmod +x speedtest
chmod +x info-menu
chmod +x vpsinfo
chmod +x status
chmod +x about
chmod +x bbr
chmod +x auto-reboot
chmod +x clear-log
chmod +x clearcache
chmod +x restart
chmod +x bw
chmod +x resett
chmod +x xp
chmod +x xray-xp
chmod +x v2ray-xp
chmod +x kernel-updt

echo "0 0 * * * root /sbin/hwclock -w   # synchronize hardware & system clock each day at 00:00 am" >> /etc/crontab
echo "0 */2 * * * root /usr/bin/clear-log # clear log every  two hours" >> /etc/crontab
echo "0 */12 * * * root /usr/bin/clearcache  #clear cache every 12hours daily" >> /etc/crontab
echo "55 23 * * * root /usr/bin/delete # delete expired user" >> /etc/crontab
echo "50 23 * * * root /usr/bin/xp # delete expired user" >> /etc/crontab
echo "35 23 * * * root /usr/bin/xray-xp # delete expired user" >> /etc/crontab
echo "15 23 * * * root /usr/bin/v2ray-xp # delete expired user" >> /etc/crontab
# remove unnecessary files
cd
apt autoclean -y
apt -y remove --purge unscd
apt-get -y --purge remove samba*;
apt-get -y --purge remove apache2*;
apt-get -y --purge remove bind9*;
apt-get -y remove sendmail*
apt autoremove -y
# finishing
cd
chown -R www-data:www-data /usr/share/nginx/html
/etc/init.d/nginx restart
/etc/init.d/openvpn restart
/etc/init.d/cron restart
/etc/init.d/ssh restart
/etc/init.d/dropbear restart
/etc/init.d/fail2ban restart
/etc/init.d/stunnel4 restart
/etc/init.d/vnstat restart
/etc/init.d/squid restart
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500
history -c
echo "unset HISTFILE" >> /etc/profile

cd
rm -f /root/key.pem
rm -f /root/cert.pem
rm -f /root/ssh-vpn.sh

# finihsing
clear
