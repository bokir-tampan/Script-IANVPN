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
echo -e "\E[0;100;33m          • SYSTEM MENU •          \E[0m"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
echo -e " [\e[36m•1\e[0m] Panel Domain"
echo -e " [\e[36m•2\e[0m] Change Port All Account"
echo -e " [\e[36m•3\e[0m] Set Auto-Backup Data VPS"
echo -e " [\e[36m•4\e[0m] Backup Data VPS"
echo -e " [\e[36m•5\e[0m] VPS Backup Info"
echo -e " [\e[36m•6\e[0m] Restore Data VPS"
echo -e " [\e[36m•7\e[0m] Webmin Menu"
echo -e " [\e[36m•8\e[0m] Limit Bandwith Speed Server"
echo -e " [\e[36m•9\e[0m] Check Usage of Ram"
echo -e " [\e[36m10\e[0m] Speedtest VPS"
echo -e " [\e[36m11\e[0m] About Script"
echo -e " [\e[36m12\e[0m] Set Auto Reboot"
echo -e " [\e[36m13\e[0m] Clear Log"
echo -e " [\e[36m14\e[0m] Restart All Service"
echo -e " [\e[36m15\e[0m] Change Banner"
echo -e " [\e[36m16\e[0m] Cek Bandwith"
echo -e " [\e[36m17\e[0m] Reset Server"
echo -e " [\e[36m18\e[0m] Kernel Update"
echo -e ""
echo -e " [\e[31m•0\e[0m] \e[31mBACK TO MENU\033[0m"
echo -e   ""
echo -e   "Press x or [ Ctrl+C ] • To-Exit"
echo -e   ""
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
read -p " Select menu : " opt
echo -e ""
case $opt in
1) clear ; m-domain ; exit ;;
2) clear ; port-change ; exit ;;
3) clear ; autobackup-setup ; exit ;; #set.br
4) clear ; backup ; exit ;; #set.br
5) clear ; backup-info ; exit ;; #set.br
6) clear ; restore ; exit ;; #set.br
7) clear ; m-webmin ; exit ;;
8) clear ; limit-speed ; exit ;; #set.br
9) clear ; ram ; exit ;;
10) clear ; speedtest ; exit ;;
11) clear ; about ; exit ;;
12) clear ; auto-reboot ; exit ;;
13) clear ; clear-log ; exit ;;
14) clear ; restart ; exit ;;
15) clear ; nano /etc/issue.net ; exit ;; #ssh-vpn banner.conf
16) clear ; bw ; exit ;;
17) clear ; resett ; exit ;;
18) clear ; kernel-updt ; exit ;;
0) clear ; menu ; exit ;;
x) exit ;;
*) echo -e "" ; echo "Boh salah tekan, Sayang kedak Babi" ; sleep 1 ; m-system ;;
esac