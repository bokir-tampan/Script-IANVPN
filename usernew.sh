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
echo -e "\E[0;100;33m         • SSH ACCOUNT •           \E[0m"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
until [[ $Login =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		read -p "Username : " Login
        CLIENT_EXISTS=$(grep -w $Login /etc/passwd | wc -l)
		#CLIENT_EXISTS=$(grep -w $Login /etc/shadowsocks-libev/akun.conf | wc -l)
		if [[ ${CLIENT_EXISTS} == '1' ]]; then
          clear
          echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
          echo -e "\E[0;100;33m         • SSH ACCOUNT •           \E[0m"
          echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
          echo ""
		  echo -e "A client with name \e[31m$Login\e[0m was already created,"
          echo -e "please choose another name"
          echo ""
          echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
		  echo ""
          read -n 1 -s -r -p "Press any key to back on menu"
          m-sshovpn
		fi
	done
read -p "Password : " Pass
read -p "Expired (hari): " masaaktif
domain=$(cat /etc/rare/xray/domain)
ssl="$(cat ~/log-install.txt | grep -w "Stunnel4" | cut -d: -f2)"
sqd="$(cat ~/log-install.txt | grep -w "Squid" | cut -d: -f2)"
sqd2="$(cat ~/log-install.txt | grep -w "Squid" | awk '{print $6}' | cut -d: -f2)" #port 8000
ovpn="$(netstat -nlpt | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
ovpn2="$(netstat -nlpu | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
proxport="$(cat /etc/squid/squid.conf | grep -i http_port | awk '{print $2}' | head -n1)"
clear
useradd -e `date -d "$masaaktif days" +"%Y-%m-%d"` -s /bin/false -M $Login
exp="$(chage -l $Login | grep "Account expires" | awk -F": " '{print $2}')"
echo -e "$Pass\n$Pass\n"|passwd $Login &> /dev/null
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[0;100;33m         • SSH ACCOUNT •           \E[0m"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Host           : $domain"
echo -e "OpenSSH        : 22"
echo -e "Dropbear       : 109, 143"
echo -e "SSL/TLS        :$ssl"
echo -e "Port Squid     :$sqd"
echo -e "OpenVPN        : TCP $ovpn https://$domain/client-tcp-$ovpn.ovpn"
echo -e "OpenVPN        : UDP $ovpn2 https://$domain/client-udp-$ovpn2.ovpn"
echo -e "OHPVPN         : OHP 8087 https://$domain/tcp-ohp.ovpn"
echo -e "badvpn         : 7300"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Username       : $Login "
echo -e "Password       : $Pass"
echo -e "Jumlah Hari    : $masaaktif Hari"
echo -e "Expired On     : $exp"
echo -e ""
echo -e "✅username pastikan semua huruf kecil"
echo -e ""
echo -e "Terima kasih ya kerana sudi membeli dari IanVPN🤗."
echo -e "Jika puas hati , jangan lupa rate 5 star ya🌟🌟🌟🌟🌟"
echo -e ""
echo -e "✅Jgn lupa join channel dibawah utk mengetahui update2 terkini tentang vpn."                                                         
echo -e "https://t.me/RidzVPN/IanVPNinternet"
echo -e ""
echo -e "✅Untuk Renew ID nanti, boleh membayar melalui dua method iaitu :-"
echo -e "1. Shopee"
echo -e "2. Direct bank in ( PM saya untuk account bank )"
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
m-sshovpn