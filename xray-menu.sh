#!/bin/bash
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
function add-user() {
	clear
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\E[0;100;33m        • ADD XRAY USER •          \E[0m"
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo ""
	read -p "Username  : " user
	if grep -qw "$user" /etc/rare/xray/clients.txt; then
		echo -e ""
		echo -e "User \e[31m$user\e[0m already exist"
		echo -e ""
		echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
        echo ""
        read -n 1 -s -r -p "Press any key to back on menu"
        xray-menu
	fi
    read -p "BUG TELCO : " BUG
	read -p "Duration (day) : " duration
	uuid=$(cat /proc/sys/kernel/random/uuid)
	exp=$(date -d +${duration}days +%Y-%m-%d)
	expired=$(date -d "${exp}" +"%d %b %Y")
	domain=$(cat /etc/rare/xray/domain)
	xtls="$(cat ~/log-install.txt | grep -w "XRAY VLESS XTLS SPLICE" | cut -d: -f2|sed 's/ //g')"
	email=${user}@${domain}
    cat>/etc/rare/xray/tls.json<<EOF
      {
       "v": "2",
       "ps": "${user}@IanVPN",
       "add": "${BUG}.${domain}",
       "port": "${xtls}",
       "id": "${uuid}",
       "aid": "0",
       "scy": "auto",
       "net": "ws",
       "type": "none",
       "host": "${BUG}",
       "path": "/xrayvws",
       "tls": "tls",
       "sni": "${BUG}"
}
EOF
    vmess_base641=$( base64 -w 0 <<< $vmess_json1)
    vmesslink1="vmess://$(base64 -w 0 /etc/rare/xray/tls.json)"
	echo -e "${user}\t${uuid}\t${exp}" >> /etc/rare/xray/clients.txt
    cat /etc/rare/xray/conf/02_VLESS_TCP_inbounds.json | jq '.inbounds[0].settings.clients += [{"id": "'${uuid}'","add": "'${domain}'","flow": "xtls-rprx-direct","email": "'${email}'"}]' > /etc/rare/xray/conf/02_VLESS_TCP_inbounds_tmp.json
	mv -f /etc/rare/xray/conf/02_VLESS_TCP_inbounds_tmp.json /etc/rare/xray/conf/02_VLESS_TCP_inbounds.json
    cat /etc/rare/xray/conf/03_VLESS_WS_inbounds.json | jq '.inbounds[0].settings.clients += [{"id": "'${uuid}'","email": "'${email}'"}]' > /etc/rare/xray/conf/03_VLESS_WS_inbounds_tmp.json
	mv -f /etc/rare/xray/conf/03_VLESS_WS_inbounds_tmp.json /etc/rare/xray/conf/03_VLESS_WS_inbounds.json
    cat /etc/rare/xray/conf/04_trojan_TCP_inbounds.json | jq '.inbounds[0].settings.clients += [{"password": "'${uuid}'","email": "'${email}'"}]' > /etc/rare/xray/conf/04_trojan_TCP_inbounds_tmp.json
	mv -f /etc/rare/xray/conf/04_trojan_TCP_inbounds_tmp.json /etc/rare/xray/conf/04_trojan_TCP_inbounds.json
    cat /etc/rare/xray/conf/05_VMess_WS_inbounds.json | jq '.inbounds[0].settings.clients += [{"id": "'${uuid}'","alterId": 0,"add": "'${domain}'","email": "'${email}'"}]' > /etc/rare/xray/conf/05_VMess_WS_inbounds_tmp.json
	mv -f /etc/rare/xray/conf/05_VMess_WS_inbounds_tmp.json /etc/rare/xray/conf/05_VMess_WS_inbounds.json
    cat <<EOF >>"/etc/rare/config-user/${user}"
vless://$uuid@$domain:$xtls?flow=xtls-rprx-direct&encryption=none&security=xtls&sni=$BUG&type=tcp&headerType=none&host=$BUG#$user@IanVPN
vless://$uuid@$domain:$xtls?flow=xtls-rprx-splice&encryption=none&security=xtls&sni=$BUG&type=tcp&headerType=none&host=$BUG#$user@IanVPN
vless://$uuid@$domain:$xtls?encryption=none&security=xtls&sni=$BUG&type=ws&host=$BUG&path=/xrayws#$user@IanVPN
trojan://$uuid@$domain:$xtls?sni=$BUG#$user@IanVPN
${vmesslink1}
EOF
    cat <<EOF >>"/etc/rare/config-url/${user}"
# =======================================
# XRAY CORE CONFIG MERLIN CLASH ASUS
# By IanVPN telegram: @IanVPN
# =======================================
proxies:
  - {name: VLess Splice ${user}@IanVPN, server: $BUG.$domain, port: $xtls, type: vless, flow: xtls-rprx-splice, uuid: $uuid, cipher: auto, tls: true, skip-cert-verify: true, network: tcp, sni: $BUG, udp: true}
  - {name: VLess Direct ${user}@IanVPN, server: $BUG.$domain, port: $xtls, type: vless, flow: xtls-rprx-direct, uuid: $uuid, cipher: auto, tls: true, skip-cert-verify: true, network: tcp, sni: $BUG, udp: true}
  - {name: VLess WS ${user}@IanVPN, server: $BUG.$domain, port: $xtls, type: vless, flow: xtls-rprx-direct, uuid: $uuid, cipher: auto, tls: true, skip-cert-verify: true, network: ws, ws-path: /xrayws, ws-headers: {Host: $BUG}, sni: $BUG, udp: true}
  - {name: Trojan ${user}@IanVPN, server: $domain, port: $xtls, type: trojan, password: $uuid, sni: $BUG, skip-cert-verify: true, udp: true}
  - {name: VMess ${user}@IanVPN, server: $domain, port: $xtls, type: vmess, uuid: $uuid, alterId: 0, cipher: auto, tls: true, skip-cert-verify: true, network: ws, ws-path: /xrayvws, ws-headers: {Host: $BUG}, udp: true}
  - {name: VMess SNI ${user}@IanVPN, server: $domain, port: $xtls, type: vmess, uuid: $uuid, alterId: 0, cipher: auto, tls: true, skip-cert-verify: true, network: ws, ws-path: /xrayvws, ws-headers: {Host: $BUG}, sni: $BUG, udp: true}
port: 3333
socks-port: 23456
redir-port: 23457
allow-lan: true
mode: global
log-level: error
external-controller: 192.168.50.1:9990
experimental:
  ignore-resolve-fail: true
external-ui: dashboard
secret: "clash"
profile:
  store-selected: true
ipv6: false

hosts:
  router.asus.com: 192.168.50.1
  services.googleapis.cn: 74.125.193.94

dns:
  enable: true
  ipv6: false
  listen: :23453
  enhanced-mode: fake-ip
  fake-ip-range: 198.18.0.1/16 
  fake-ip-filter:
    - '*.lan'
    - '*.linksys.com'
    - '*.linksyssmartwifi.com'
    - 'swscan.apple.com'
    - 'mesu.apple.com'
    - '*.msftconnecttest.com'
    - '*.msftncsi.com'
    # === NTP Service ===
    - 'time.*.com'
    - 'time.*.gov'
    - 'time.*.edu.cn'
    - 'time.*.apple.com'
    - 'time1.*.com'
    - 'time2.*.com'
    - 'time3.*.com'
    - 'time4.*.com'
    - 'time5.*.com'
    - 'time6.*.com'
    - 'time7.*.com'
    - 'ntp.*.com'
    - 'ntp.*.com'
    - 'ntp1.*.com'
    - 'ntp2.*.com'
    - 'ntp3.*.com'
    - 'ntp4.*.com'
    - 'ntp5.*.com'
    - 'ntp6.*.com'
    - 'ntp7.*.com'
    - '*.time.edu.cn'
    - '*.ntp.org.cn'
    - '+.pool.ntp.org'
    - 'time1.cloud.tencent.com'
    # === Music Service ===
    ## NetEase
    - '+.music.163.com'
    - '+.126.net'
    ## Baidu
    - 'musicapi.taihe.com'
    - 'music.taihe.com'
    ## Kugou
    - 'songsearch.kugou.com'
    - 'trackercdn.kugou.com'
    ## Kuwo
    - '*.kuwo.cn'
    ## JOOX
    - 'api-jooxtt.sanook.com'
    - 'api.joox.com'
    - 'joox.com'
    ## QQ
    - '+.music.tc.qq.com'
    - 'aqqmusic.tc.qq.com'
    - '+.stream.qqmusic.qq.com'
    ## Xiami
    - '+.xiami.com'
    ## Migu
    - '+.music.migu.cn'
    # === Game Service ===
    ## Nintendo Switch
    - '+.srv.nintendo.net'
    ## Sony PlayStation
    - '+.stun.playstation.net'
    ## Microsoft Xbox
    - 'xbox.*.microsoft.com'
    - '+.xboxlive.com'
    # === Other ===
    ## QQ Quick Login
    - 'localhost.ptlogin2.qq.com'
    ## Golang
    - 'proxy.golang.org'
    ## STUN Server
    - 'stun.*.*'
    - 'stun.*.*.*'
    # === ?? ===
    - '+.qq.com'
    - '+.baidu.com'
    - '+.163.com'
    - '+.126.net'
    - '+.taobao.com'
    - '+.jd.com'
    - '+.tmall.com'
  nameserver:
    - 119.29.29.29
    - 223.5.5.5
    - 180.76.76.76
  fallback:
    - https://doh.dns.sb/dns-query
    - tcp://208.67.222.222:443
    - tls://dns.google
  fallback-filter:
    geoip: true
    ipcidr:
      - 240.0.0.0/4
tproxy: true
tproxy-port: 23458
EOF
	base64Result=$(base64 -w 0 /etc/rare/config-user/${user})
    echo ${base64Result} >"/etc/rare/config-url/${uuid}"
    systemctl restart xray.service
    echo -e "\033[32m[Info]\033[0m xray Start Successfully !"
    sleep 2
    clear
	echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\E[0;100;33m    • XRAY USER INFORMATION •      \E[0m"
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"  
	echo -e ""   
	echo -e " Username      : $user"
	echo -e " Expired date  : $expired"
    echo -e " Jumlah Hari   : $duration Hari"
    echo -e " PORT          : $xtls"
    echo -e " UUID/PASSWORD : $uuid"
	echo -e ""
	echo -e " Pantang Larang IanVPN"
	echo -e " ‼️Aktiviti Berikut Adalah Dilarang"
    echo -e " (ID akan di ban tanpa notis & tiada refund)"
	echo -e " ❌Torrent (p2p, streaming p2p)"
	echo -e " ❌PS4"
	echo -e " ❌Porn"
	echo -e " ❌Ddos Server"
	echo -e " ❌Mining Bitcoins"
	echo -e " ❌Abuse Usage"
	echo -e " ❌Multi-Login ID"
	echo -e " ❌Sharing Premium Config"
    echo -e ""
	echo -e " Ip Vps        : $MYIP"
    echo -e " Domain        : $domain"
	echo -e " Bug Domain    : $BUG"    	
	echo -e ""
	echo -e " Link VLESS SPLICE: vless://$uuid@$BUG.$domain:$xtls?flow=xtls-rprx-splice&encryption=none&security=xtls&sni=$BUG&type=tcp&headerType=none&host=$BUG#$user@IanVPN"
    echo -e ""
    echo -e " Link VLESS DIRECT: vless://$uuid@$BUG.$domain:$xtls?flow=xtls-rprx-direct&encryption=none&security=xtls&sni=$BUG&type=tcp&headerType=none&host=$BUG#$user@IanVPN"
    echo -e ""
	echo -e " Link VLESS WS: vless://$uuid@$BUG.$domain:$xtls?encryption=none&security=xtls&sni=$BUG&type=ws&host=$BUG&path=/xrayws#$user@IanVPN"
    echo -e ""
	echo -e " Link TROJAN: trojan://$uuid@$BUG.$domain:$xtls?sni=$BUG#$user@IanVPN"
    echo -e ""
    echo -e " Link VMESS TLS: ${vmesslink1}"
	echo -e ""
    echo -e " Link url OPENWRT/xrayN PC: https://${domain}/s/${uuid}"
	echo -e ""
	echo -e " Link url ASUS Clash: https://${domain}/s/${user}" 
	echo -e ""
	echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo ""
    read -n 1 -s -r -p "Press any key to back on menu"
    xray-menu   
}

function delete-user() {
	clear
	echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\E[0;100;33m       • DELETE XRAY USER •        \E[0m"
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e ""  
	read -p "Username : " user
	echo -e ""
	if ! grep -qw "$user" /etc/rare/xray/clients.txt; then
		echo -e ""
        echo -e "User \e[31m$user\e[0m does not exist"
        echo ""
        echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
        echo ""
        read -n 1 -s -r -p "Press any key to back on menu"
        xray-menu   
	fi
    rm /etc/rare/config-url/${user}
	uuid="$(cat /etc/rare/xray/clients.txt | grep -w "$user" | awk '{print $2}')"
	cat /etc/rare/xray/conf/02_VLESS_TCP_inbounds.json | jq 'del(.inbounds[0].settings.clients[] | select(.id == "'${uuid}'"))' > /etc/rare/xray/conf/02_VLESS_TCP_inbounds_tmp.json
	mv -f /etc/rare/xray/conf/02_VLESS_TCP_inbounds_tmp.json /etc/rare/xray/conf/02_VLESS_TCP_inbounds.json
    cat /etc/rare/xray/conf/03_VLESS_WS_inbounds.json | jq 'del(.inbounds[0].settings.clients[] | select(.id == "'${uuid}'"))' > /etc/rare/xray/conf/03_VLESS_WS_inbounds_tmp.json
	mv -f /etc/rare/xray/conf/03_VLESS_WS_inbounds_tmp.json /etc/rare/xray/conf/03_VLESS_WS_inbounds.json
    cat /etc/rare/xray/conf/04_trojan_TCP_inbounds.json | jq 'del(.inbounds[0].settings.clients[] | select(.password == "'${uuid}'"))' > /etc/rare/xray/conf/04_trojan_TCP_inbounds_tmp.json
	mv -f /etc/rare/xray/conf/04_trojan_TCP_inbounds_tmp.json /etc/rare/xray/conf/04_trojan_TCP_inbounds.json		
    cat /etc/rare/xray/conf/05_VMess_WS_inbounds.json | jq 'del(.inbounds[0].settings.clients[] | select(.id == "'${uuid}'"))' > /etc/rare/xray/conf/05_VMess_WS_inbounds_tmp.json
	mv -f /etc/rare/xray/conf/05_VMess_WS_inbounds_tmp.json /etc/rare/xray/conf/05_VMess_WS_inbounds.json
    sed -i "/\b$user\b/d" /etc/rare/xray/clients.txt
    rm /etc/rare/config-user/${user}
    rm /etc/rare/config-url/${uuid}
	systemctl restart xray.service
    echo -e "\033[32m[Info]\033[0m xray Start Successfully !"
    echo ""
	echo -e "User \e[32m$user\e[0m deleted Successfully !"
	echo ""
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo ""
    read -n 1 -s -r -p "Press any key to back on menu"
    xray-menu 
}

function extend-user() {
	clear
	echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\E[0;100;33m       • EXTEND XRAY USER •        \E[0m"
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo ""
	read -p "Username : " user
	if ! grep -qw "$user" /etc/rare/xray/clients.txt; then
		echo -e ""
		echo -e "User \e[31m$user\e[0m does not exist"
        echo ""
        echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
        echo ""
        read -n 1 -s -r -p "Press any key to back on menu"
        xray-menu 
	fi
	read -p "Duration (day) : " extend
	uuid=$(cat /etc/rare/xray/clients.txt | grep -w $user | awk '{print $2}')
	exp_old=$(cat /etc/rare/xray/clients.txt | grep -w $user | awk '{print $3}')
	diff=$((($(date -d "${exp_old}" +%s)-$(date +%s))/(86400)))
	duration=$(expr $diff + $extend + 1)
	exp_new=$(date -d +${duration}days +%Y-%m-%d)
	exp=$(date -d "${exp_new}" +"%d %b %Y")
	sed -i "/\b$user\b/d" /etc/rare/xray/clients.txt
	echo -e "$user\t$uuid\t$exp_new" >> /etc/rare/xray/clients.txt
	clear
	echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\E[0;100;33m    • XRAY USER INFORMATION •      \E[0m"
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo ""
	echo -e "Username     : $user"
	echo -e "Expired date : $exp"
	echo -e ""
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo ""
    read -n 1 -s -r -p "Press any key to back on menu"
    xray-menu     
}

function user-list() {
	clear
	echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\E[0;100;33m        • XRAY USER LIST •         \E[0m"
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo ""
    echo -e  "\e[36mUsername               Exp. Date\e[0m"
    echo ""   
	while read expired
	do
		user=$(echo $expired | awk '{print $1}')
		exp=$(echo $expired | awk '{print $3}')
		exp_date=$(date -d"${exp}" "+%d %b %Y")
		printf "%-17s %2s\n" "$user" "     $exp_date"
	done < /etc/rare/xray/clients.txt
	total=$(wc -l /etc/rare/xray/clients.txt | awk '{print $1}')
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "Total accounts: $total"
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
	echo -e ""
    read -n 1 -s -r -p "Press any key to back on menu"
    xray-menu
}

function user-monitor() {
    clear
	echo -n > /tmp/other.txt
	data=($(cat /etc/rare/xray/clients.txt | awk '{print $1}'));
	echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\E[0;100;33m      • XRAY USER MONITOR •        \E[0m"
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo ""
	for akun in "${data[@]}"
	do
	if [[ -z "$akun" ]]; then
	akun="tidakada"
	fi
	echo -n > /tmp/ipvmess.txt
	data2=( `netstat -anp | grep ESTABLISHED | grep tcp6 | grep xray | awk '{print $5}' | cut -d: -f1 | sort | uniq`);
	for ip in "${data2[@]}"
	do
	jum=$(cat /var/log/xray/access.log | grep -w $akun | awk '{print $3}' | cut -d: -f1 | grep -w $ip | sort | uniq)
    if [[ "$jum" = "$ip" ]]; then
	echo "$jum" >> /tmp/ipvmess.txt
	else
	echo "$ip" >> /tmp/other.txt
	fi
	jum2=$(cat /tmp/ipvmess.txt)
	sed -i "/$jum2/d" /tmp/other.txt > /dev/null 2>&1
	done
	jum=$(cat /tmp/ipvmess.txt)
	if [[ -z "$jum" ]]; then
	echo > /dev/null
	else
	jum2=$(cat /tmp/ipvmess.txt | nl)
	echo "user : $akun";
	echo "$jum2";
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
	fi
	rm -rf /tmp/ipvmess.txt
	done
	oth=$(cat /tmp/other.txt | sort | uniq | nl)
	echo "other";
	echo "$oth";
	echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
	rm -rf /tmp/other.txt
	echo -e ""
    read -n 1 -s -r -p "Press any key to back on menu"
    xray-menu      
}

function show-config() {
	echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\E[0;100;33m       • XRAY USER CONFIG •        \E[0m"
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e ""
	read -p "User : " user
	if ! grep -qw "$user" /etc/rare/xray/clients.txt; then
		echo -e ""
		echo -e "User \e[31m$user\e[0m does not exist"
		echo -e ""
        read -n 1 -s -r -p "Press any key to back on menu"
        xray-menu
	fi
    xtls="$(cat ~/log-install.txt | grep -w "XRAY VLESS XTLS SPLICE" | cut -d: -f2|sed 's/ //g')"
    link=$(cat /etc/rare/config-user/${user})
	uuid=$(cat /etc/rare/xray/clients.txt | grep -w "$user" | awk '{print $2}')
	domain=$(cat /etc/rare/xray/domain)
	exp=$(cat /etc/rare/xray/clients.txt | grep -w "$user" | awk '{print $3}')
	exp_date=$(date -d"${exp}" "+%d %b %Y")

	clear
	echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\E[0;100;33m    • XRAY USER INFORMATION •      \E[0m"
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"      
	echo -e ""
	echo -e " Username      : $user"
	echo -e " Expired date  : $exp_date"
	echo -e " Ip Vps        : $MYIP"
    echo -e " Domain        : $domain"
    echo -e " PORT          : $xtls"
    echo -e " UUID/PASSWORD : $uuid"
	echo -e ""
    echo -e " Link url OPENWRT/V2rayN PC: https://${domain}/s/${uuid}"
	echo -e ""
	echo -e " Link url ASUS Clash: https://${domain}/s/${user}"
    echo -e ""
    echo -e " Config :"
	echo -e " $link"  
	echo -e ""
	echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo ""
    read -n 1 -s -r -p "Press any key to back on menu"
    xray-menu    
}

function change-port() {
	clear
    xtls="$(cat ~/log-install.txt | grep -w "XRAY VLESS XTLS SPLICE" | cut -d: -f2|sed 's/ //g')"
	echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\E[0;100;33m       • CHANGE PORT XRAY •        \E[0m"
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e ""
	echo -e "Change Port XRAY TCP XTLS: $xtls"
	echo -e ""
	read -p "New Port XRAY TCP XTLS: " xtls1
	if [ -z $xtls1 ]; then
	echo "Please Input Port"
	echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo ""
    read -n 1 -s -r -p "Press any key to back on menu"
    change-port  	
	fi
	cek=$(netstat -nutlp | grep -w $xtls1)
    if [[ -z $cek ]]; then
    sed -i "s/$xtls/$xtls1/g" /etc/rare/xray/conf/02_VLESS_TCP_inbounds.json
    sed -i "s/   - XRAY VLESS XTLS SPLICE  : $xtls/   - XRAY VLESS XTLS SPLICE : $xtls1/g" /root/log-install.txt
    sed -i "s/   - XRAY VLESS XTLS DIRECT  : $xtls/   - XRAY VLESS XTLS DIRECT  : $xtls1/g" /root/log-install.txt
    sed -i "s/   - XRAY VLESS WS TLS       : $xtls/   - XRAY VLESS WS TLS       : $xtls1/g" /root/log-install.txt
	sed -i "s/   - XRAY TROJAN TLS         : $xtls/   - XRAY TROJAN TLS         : $xtls1/g" /root/log-install.txt
    sed -i "s/   - XRAY VMESS TLS          : $xtls/   - XRAY VMESS TLS          : $xtls1/g" /root/log-install.txt
    iptables -D INPUT -m state --state NEW -m tcp -p tcp --dport $xtls -j ACCEPT
    iptables -D INPUT -m state --state NEW -m udp -p udp --dport $xtls -j ACCEPT
    iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport $xtls1 -j ACCEPT
    iptables -I INPUT -m state --state NEW -m udp -p udp --dport $xtls1 -j ACCEPT
    iptables-save > /etc/iptables.up.rules
    iptables-restore -t < /etc/iptables.up.rules
    netfilter-persistent save > /dev/null
    netfilter-persistent reload > /dev/null
    systemctl restart xray > /dev/null
    echo -e "\033[32m[Info]\033[0m xray Start Successfully !"
    echo ""
    echo -e "\e[032;1mPort $xtls1 modified Successfully !\e[0m"
	echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo ""
    read -n 1 -s -r -p "Press any key to back on menu"
    xray-menu    
    else
    echo "Port $xtls1 is used"
	echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo ""
    read -n 1 -s -r -p "Press any key to back on menu"
    change-port      
    fi
}

clear
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[0;100;33m       • XRAY CORE MENU •          \E[0m"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""   
echo -e " [\e[36m•1\e[0m] Add XRAY user "
echo -e " [\e[36m•2\e[0m] Delete XRAY user "
echo -e " [\e[36m•3\e[0m] Extend XRAY user "
echo -e " [\e[36m•4\e[0m] View user list "
echo -e " [\e[36m•5\e[0m] Monitor user "
echo -e " [\e[36m•6\e[0m] Show User config "
echo -e " [\e[36m•7\e[0m] Change Port XRAY "
echo -e ""
echo -e " [\e[31m•0\e[0m] \e[31mBACK TO MENU\033[0m"
echo -e   ""
echo -e   "Press x or [ Ctrl+C ] • To-Exit"
echo -e ""
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
read -p " Select menu : " opt
echo -e ""
case $opt in
1) clear ; add-user ;;
2) clear ; delete-user ;;
3) clear ; extend-user ;;
4) clear ; user-list ;;
5) clear ; user-monitor ;;
6) clear ; show-config ;;
7) clear ; change-port ;;
0) clear ; menu ;;
x) exit ;;
*) echo -e "" ; echo "Boh salah tekan, Sayang kedak Babi" ; sleep 1 ; xray-menu ;;
esac