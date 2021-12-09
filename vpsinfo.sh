#!/bin/bash
MYIP=$(wget -qO- icanhazip.com);
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
# VPS Information
Checkstart1=$(ip route | grep default | cut -d ' ' -f 3 | head -n 1);
if [[ $Checkstart1 == "venet0" ]]; then 
    clear
	  lan_net="venet0"
    typevps="OpenVZ"
    sleep 1
else
    clear
		lan_net="eth0"
    typevps="KVM"
    sleep 1
fi
# Getting OS Information
source /etc/os-release
Versi_OS=$VERSION
ver=$VERSION_ID
Tipe=$NAME
URL_SUPPORT=$HOME_URL
basedong=$ID
# VPS ISP INFORMATION
ITAM='\033[0;30m'
echo -e "$ITAM"
NAMAISP=$( curl -s ipinfo.io/org | cut -d " " -f 2-10  )
REGION=$( curl -s ipinfo.io/region )
COUNTRY=$( curl -s ipinfo.io/country )
WAKTU=$( curl -s ipinfo.ip/timezone )
CITY=$( curl -s ipinfo.io/city )
REGION=$( curl -s ipinfo.io/region )
WAKTUE=$( curl -s ipinfo.io/timezone )
koordinat=$( curl -s ipinfo.io/loc )
# Color Validation
yell='\e[33m'
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
ORANGE='\e[33m '
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT='\033[0;37m'
# Download
#Download/Upload today
dtoday="$(vnstat -i eth0 | grep "today" | awk '{print $2" "substr ($3, 1, 1)}')"
utoday="$(vnstat -i eth0 | grep "today" | awk '{print $5" "substr ($6, 1, 1)}')"
ttoday="$(vnstat -i eth0 | grep "today" | awk '{print $8" "substr ($9, 1, 1)}')"
#Download/Upload yesterday
dyest="$(vnstat -i eth0 | grep "yesterday" | awk '{print $2" "substr ($3, 1, 1)}')"
uyest="$(vnstat -i eth0 | grep "yesterday" | awk '{print $5" "substr ($6, 1, 1)}')"
tyest="$(vnstat -i eth0 | grep "yesterday" | awk '{print $8" "substr ($9, 1, 1)}')"
#Download/Upload current month
dmon="$(vnstat -i eth0 -m | grep "`date +"%b '%y"`" | awk '{print $3" "substr ($4, 1, 1)}')"
umon="$(vnstat -i eth0 -m | grep "`date +"%b '%y"`" | awk '{print $6" "substr ($7, 1, 1)}')"
tmon="$(vnstat -i eth0 -m | grep "`date +"%b '%y"`" | awk '{print $9" "substr ($10, 1, 1)}')"
# Ram Usage
total_r2am=` grep "MemAvailable: " /proc/meminfo | awk '{ print $2}'`
MEMORY=$(($total_r2am/1024))
# Total Ram
total_ram=` grep "MemTotal: " /proc/meminfo | awk '{ print $2}'`
totalram=$(($total_ram/1024))
# Tipe Processor
totalcore="$(grep -c "^processor" /proc/cpuinfo)" 
totalcore+=" Core"
corediilik="$(grep -c "^processor" /proc/cpuinfo)" 
tipeprosesor="$(awk -F ': | @' '/model name|Processor|^cpu model|chip type|^cpu type/ {
                        printf $2;
                        exit
                        }' /proc/cpuinfo)"
# Shell Version
shellversion=""
shellversion=Bash
shellversion+=" Version" 
shellversion+=" ${BASH_VERSION/-*}" 
versibash=$shellversion
# Getting CPU Information
cpu_usage1="$(ps aux | awk 'BEGIN {sum=0} {sum+=$3}; END {print sum}')"
cpu_usage="$((${cpu_usage1/\.*} / ${corediilik:-1}))"
cpu_usage+=" %"
# OS Uptime
uptime="$(uptime -p | cut -d " " -f 2-10)"
# Kernel Terbaru
kernelku=$(uname -r)
# Waktu Sekarang 
harini=`date -d "0 days" +"%d-%m-%Y"`
jam=`date -d "0 days" +"%X"`
# DNS Patch
tipeos2=$(uname -m)
# Getting Domain Name
Domen="$(cat /etc/rare/xray/domain)"
# Echoing Result
clear
echo -e "\e[33m ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e " \E[0;100;33m          Sayang ktk Lillian               \E[0m"
echo -e "\e[33m ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "   \e[33m "
echo -e "   \e[33m VPS Type   \033[0m : $typevps"
echo -e "   \e[33m OS Arch    \033[0m : $tipeos2"
echo -e "   \e[33m Hostname   \033[0m : $HOSTNAME"
echo -e "   \e[33m OS Name    \033[0m : $Tipe"
echo -e "   \e[33m OS Version \033[0m : $Versi_OS"
echo -e "   \e[33m OS URL     \033[0m : $URL_SUPPORT"
echo -e "   \e[33m OS BASE    \033[0m : $basedong"
echo -e "   \e[33m OS TYPE    \033[0m : Linux / Unix"
echo -e "   \e[33m Bash Ver   \033[0m : $versibash"
echo -e "   \e[33m Kernel Ver \033[0m : $kernelku"
echo -e "   \e[33m Processor  \033[0m : $tipeprosesor"
echo -e "   \e[33m Proc Core  \033[0m : $totalcore"
echo -e "   \e[33m Virtual    \033[0m : $typevps"
echo -e "   \e[33m Cpu Usage  \033[0m : $cpu_usage"
echo -e "   \e[33m Uptime     \033[0m : $uptime"
echo -e "   \e[33m Total RAM  \033[0m : ${totalram}MB"
echo -e "   \e[33m Avaible    \033[0m : ${MEMORY}MB"
echo -e "   \e[33m Public IP  \033[0m : $MYIP"
echo -e "   \e[33m Domain     \033[0m : $Domen"
echo -e "   \e[33m ISP Name   \033[0m : $NAMAISP"
echo -e "   \e[33m Region     \033[0m : $REGION "
echo -e "   \e[33m Country    \033[0m : $COUNTRY"
echo -e "   \e[33m City       \033[0m : $CITY "
echo -e "   \e[33m Time Zone  \033[0m : $WAKTUE"
echo -e "   \e[33m Location   \033[0m : $COUNTRY"
echo -e "   \e[33m Coordinate \033[0m : $koordinat"
echo -e "   \e[33m Time Zone  \033[0m : $WAKTUE"
echo -e "   \e[33m Date       \033[0m : $harini"
echo -e "   \e[33m Time       \033[0m : $jam ( WIB )"
echo -e "\e[33m ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e  "$PURPLE   Traffic$NC       \e[33mToday      Yesterday     Month   "
echo -e  "\e[33m   Download$NC      $dtoday    $dyest       $dmon   $NC"
echo -e  "\e[33m   Upload$NC        $utoday    $uyest       $umon   $NC"
echo -e  "\e[33m   Total$NC       \033[0;36m  $ttoday    $tyest       $tmon  $NC "
echo -e "\e[33m ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
read -n 1 -s -r -p "Press any key to back on  menu"
menu