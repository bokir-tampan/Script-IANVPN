#!/bin/bash
# v2ray Auto Setup 
# =========================
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[information]${Font_color_suffix}"
MYIP=$(wget -qO- ipinfo.io/ip);
echo "Checking VPS"
CEKEXPIRED () {
    today=$(date -d +1day +%Y-%m-%d)
    Exp1=$(curl -sS https://raw.githubusercontent.com/Iansoftware/userip/main/bossip | grep $MYIP | awk '{print $3}')
    if [[ $today < $Exp1 ]]; then
    echo -e "\e[32mSTATUS SCRIPT AKTIF...\e[0m"
    else
    echo -e "\e[31mSCRIPT ANDA EXPIRED!\e[0m";
    echo -e "\e[31mRenew IP letak tempoh banyak kit okay? hehe syg ktk #\e[0m"
    exit 0
fi
}
IZIN=$(curl -sS https://raw.githubusercontent.com/Iansoftware/userip/main/bossip | awk '{print $4}' | grep $MYIP)
if [ $MYIP = $IZIN ]; then
echo -e "\e[32mPermission Accepted...\e[0m"
CEKEXPIRED
else
echo -e "\e[31mPermission Denied!\e[0m";
echo -e "\e[31mDaftar IP dalam github lok sayang okay? mun dah daftar tapi masih juak permission denied refresh dolok website ya hehe. Love you #\e[0m"
exit 0
fi
clear
echo -e "${Info} V2ray CORE VPS AutoScript by IanVPN"
# Detect public IPv4 address and pre-fill for the user
# Domain
domain=$(cat /etc/rare/xray/domain)
# Uuid Service
uuid=$(cat /proc/sys/kernel/random/uuid)
echo -e "\e[0;32m V2ray CORE VPS AutoScript by IanVPN\e[0m"
echo -e "\e[0;32m TELEGRAM @IanVPN\e[0m"
sleep 5
# NGINX V2RAY CONF
sudo pkill -f nginx & wait $!
systemctl stop nginx
touch /etc/nginx/conf.d/alone2.conf
cat <<EOF >>/etc/nginx/conf.d/alone2.conf
server {
	listen 82;
	listen [::]:82;
	server_name ${domain};
	# shellcheck disable=SC2154
	return 301 https://${domain};
}
server {
		listen 127.0.0.1:32300;
		server_name _;
		return 403;
}
server {
	listen 127.0.0.1:31402 http2;
	server_name ${domain};
	root /usr/share/nginx/html;
	location /s/ {
    		add_header Content-Type text/plain;
    		alias /etc/rare/config-url/;
    }

    location /v2raygrpc {
		client_max_body_size 0;
#		keepalive_time 1071906480m;
		keepalive_requests 4294967296;
		client_body_timeout 1071906480m;
 		send_timeout 1071906480m;
 		lingering_close always;
 		grpc_read_timeout 1071906480m;
 		grpc_send_timeout 1071906480m;
		grpc_pass grpc://127.0.0.1:32301;
	}

	location /v2raytrojangrpc {
		client_max_body_size 0;
		# keepalive_time 1071906480m;
		keepalive_requests 4294967296;
		client_body_timeout 1071906480m;
 		send_timeout 1071906480m;
 		lingering_close always;
 		grpc_read_timeout 1071906480m;
 		grpc_send_timeout 1071906480m;
		grpc_pass grpc://127.0.0.1:32304;
	}
}
server {
	listen 127.0.0.1:32300;
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
systemctl daemon-reload
service nginx restart
# INSTALL v2ray
wget -c -P /etc/rare/v2ray/ "https://github.com/v2fly/v2ray-core/releases/download/v4.42.2/v2ray-linux-64.zip"
unzip -o /etc/rare/v2ray/v2ray-linux-64.zip -d /etc/rare/v2ray
rm -rf /etc/rare/v2ray/v2ray-linux-64.zip
# v2ray boot service
rm -rf /etc/systemd/system/v2ray.service
touch /etc/systemd/system/v2ray.service
cat <<EOF >/etc/systemd/system/v2ray.service
[Unit]
Description=V2Ray - A unified platform for anti-censorship
Documentation=https://v2ray.com https://guide.v2fly.org
After=network.target nss-lookup.target
Wants=network-online.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_BIND_SERVICE CAP_NET_RAW
NoNewPrivileges=yes
ExecStart=/etc/rare/v2ray/v2ray -confdir /etc/rare/v2ray/conf
Restart=on-failure
RestartPreventExitStatus=23


[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable v2ray.service
rm -rf /etc/rare/v2ray/conf/*
cat <<EOF >/etc/rare/v2ray/conf/00_log.json
{
  "log": {
    "access": "/var/log/v2ray/access.log",
    "error": "/var/log/v2ray/error.log",
    "loglevel": "warning"
  }
}
EOF
cat <<EOF >/etc/rare/v2ray/conf/10_ipv4_outbounds.json
{
    "outbounds":[
        {
            "protocol":"freedom",
            "settings":{
                "domainStrategy":"UseIPv4"
            },
            "tag":"IPv4-out"
        },
        {
            "protocol":"freedom",
            "settings":{
                "domainStrategy":"UseIPv6"
            },
            "tag":"IPv6-out"
        },
        {
            "protocol":"blackhole",
            "tag":"blackhole-out"
        }
    ]
}
EOF
cat <<EOF >/etc/rare/v2ray/conf/11_dns.json
{
    "dns": {
        "servers": [
          "localhost"
        ]
  }
}
EOF
cat <<EOF >/etc/rare/v2ray/conf/02_VLESS_TCP_inbounds.json
{
  "inbounds": [
    {
      "port": 8080,
      "protocol": "vless",
      "tag": "V2VLESSTCP",
      "settings": {
        "clients": [],
        "decryption": "none",
        "fallbacks": [
          {
            "dest": 32296,
            "xver": 1
          },
          {
            "alpn": "h2",
            "dest": 32302,
            "xver": 0
          },
          {
            "path": "/v2rayws",
            "dest": 32297,
            "xver": 1
          },
          {
            "path": "/v2rayvws",
            "dest": 32299,
            "xver": 1
          }
        ]
      },
      "streamSettings": {
        "network": "tcp",
        "security": "tls",
        "tlsSettings": {
          "alpn": [
            "http/1.1",
            "h2"
          ],
          "certificates": [
            {
              "certificateFile": "/etc/rare/xray/xray.crt",
              "keyFile": "/etc/rare/xray/xray.key"
            }
          ]
        }
      }
    }
  ]
}
EOF
cat <<EOF >/etc/rare/v2ray/conf/03_VLESS_WS_inbounds.json
{
  "inbounds": [
    {
      "port": 32297,
      "listen": "127.0.0.1",
      "protocol": "vless",
      "tag": "V2VLESSWS",
      "settings": {
        "clients": [],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": {
          "acceptProxyProtocol": true,
          "path": "/v2rayws"
        }
      }
    }
  ]
}
EOF
cat <<EOF >/etc/rare/v2ray/conf/04_trojan_TCP_inbounds.json
{
  "inbounds": [
    {
      "port": 32296,
      "listen": "127.0.0.1",
      "protocol": "trojan",
      "tag": "V2trojanTCP",
      "settings": {
        "clients": [],
        "fallbacks": [
          {
            "dest": "32300"
          }
        ]
      },
      "streamSettings": {
        "network": "tcp",
        "security": "none",
        "tcpSettings": {
          "acceptProxyProtocol": true
        }
      }
    }
  ]
}
EOF
cat <<EOF >/etc/rare/v2ray/conf/05_VMess_WS_inbounds.json
{
  "inbounds": [
    {
      "listen": "127.0.0.1",
      "port": 32299,
      "protocol": "vmess",
      "tag": "V2VMessWS",
      "settings": {
        "clients": []
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": {
          "acceptProxyProtocol": true,
          "path": "/v2rayvws"
        }
      }
    }
  ]
}
EOF
cat <<EOF >/etc/rare/v2ray/conf/06_VLESS_gRPC_inbounds.json
{
    "inbounds":[
    {
        "port": 32301,
        "listen": "127.0.0.1",
        "protocol": "vless",
        "tag":"V2VLESSGRPC",
        "settings": {
            "clients": [],
            "decryption": "none"
        },
        "streamSettings": {
            "network": "grpc",
            "grpcSettings": {
                "serviceName": "v2raygrpc"
            }
        }
    }
]
}
EOF
# v2ray
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 8080 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 32301 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 32299 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 32296 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 32297 -j ACCEPT
# v2ray
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 8080 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 32301 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 32299 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 32296 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 32297 -j ACCEPT
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload
systemctl daemon-reload
systemctl restart v2ray
systemctl enable v2ray
systemctl restart v2ray.service
systemctl enable v2ray.service

cd /usr/bin
wget -O v2ray-menu "https://raw.githubusercontent.com/Iansoftware/Script-IANVPN/main/v2ray-menu.sh"
chmod +x v2ray-menu
cd
systemctl daemon-reload
systemctl restart nginx
systemctl restart v2ray
