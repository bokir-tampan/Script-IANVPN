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
clear 
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[0;100;33m         • RESET SERVER •          \E[0m"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
echo -e "[ \033[32mInfo\033[0m ] RESET Begin"
systemctl daemon-reload
echo -e "[ \033[32mok\033[0m ] daemon-reload Service Restarted"
systemctl restart xray
echo -e "[ \033[32mok\033[0m ] xray Service Restarted"
systemctl restart xray.service
echo -e "[ \033[32mok\033[0m ] xray.service Service Restarted"
systemctl restart v2ray
echo -e "[ \033[32mok\033[0m ] v2ray Service Restarted"
systemctl restart v2ray.service
echo -e "[ \033[32mok\033[0m ] v2ray.service Service Restarted"
systemctl restart trojan
echo -e "[ \033[32mok\033[0m ] trojan Service Restarted"
systemctl restart shadowsocks-libev
echo -e "[ \033[32mok\033[0m ] shadowsocks-libev Service Restarted"
systemctl restart ssrmu
echo -e "[ \033[32mok\033[0m ] ssrmu Service Restarted"
systemctl restart wg-quick@wg0
echo -e "[ \033[32mok\033[0m ] wg-quick@wg0 Service Restarted"
systemctl restart ssh
echo -e "[ \033[32mok\033[0m ] SSH Service Restarted"
systemctl restart stunnel4
echo -e "[ \033[32mok\033[0m ] stunnel4 Service Restarted"
systemctl restart dropbear
echo -e "[ \033[32mok\033[0m ] dropbear Service Restarted"
systemctl restart openvpn
echo -e "[ \033[32mok\033[0m ] openvpn Service Restarted"
systemctl restart nginx
echo -e "[ \033[32mok\033[0m ] nginx Service Restarted"
systemctl restart squid
echo -e "[ \033[32mok\033[0m ] squid Service Restarted"
systemctl restart cron
echo -e "[ \033[32mok\033[0m ] cron Service Restarted"
systemctl restart fail2ban
echo -e "[ \033[32mok\033[0m ] fail2ban Service Restarted"
systemctl restart vnstat
echo -e "[ \033[32mok\033[0m ] vnstat Service Restarted"
sleep 1
echo -e "[ \033[32mInfo\033[0m ] ALL Service Reset"
echo ""
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
read -n 1 -s -r -p "Press any key to back on system menu"
m-system
