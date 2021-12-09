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
cd /root
rm /root/zippass &> /dev/null
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[0;100;33m     • SETUP AUTO BACKUP •         \E[0m"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "" 
echo -e "Create password Backup ZIP File"
echo -e "" 
read -e -p "Enter password : " password
echo -e "password=$password" >> /root/zippass
echo "0 5 * * * root /usr/bin/autobackup # Autobackup VPS 5AM Every day" >> /etc/crontab
sleep 2
echo -e "" 
echo -e "[\e[32mINFO\e[0m] SETUP AUTO BACKUP 5AM EVERY DAY Successfully !"
# source /root/zippass
# password=$password
echo -e "" 
echo -e "[\e[32mINFO\e[0m] Processing AUTO BACKUP"
sleep 2
autobackup
echo -e "Link location /root/linkbackup"
echo -e ""
read -n 1 -s -r -p "Press any key to back on menu"
m-system
