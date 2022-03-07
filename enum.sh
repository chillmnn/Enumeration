#!/bin/bash

url=$1

 if [ -z "$1" ]
  then
   echo "                                                        "
   echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
   echo "                                                        "
   echo "Please specify a target IP or target domain."
   echo "Usage: ./enum.sh <example.com>"
   echo "                                                        "
   echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
   echo "                                                        "
        exit 1

 fi

 if [ ! -d "$url" ];then
 	mkdir $url
 fi

 if [ ! -d "$url/enum" ];then
 	mkdir $url/enum
 fi
 
 if [ ! -d "$url/enum/nmap" ];then
 	mkdir $url/enum/nmap
 fi
 
 if [ ! -d "$url/enum/masscan" ];then
 	mkdir $url/enum/masscan
 fi
 
 if [ ! -d "$url/enum/sublist3r" ];then
 	mkdir $url/enum/sublist3r
 fi
 
 if [ ! -d "$url/enum/amass" ];then
 	mkdir $url/enum/amass
 fi

 if [ ! -d "$url/enum/httprobe" ];then
 	mkdir $url/enum/httprobe
 fi
  
 if [ ! -d '$url/enum/aquatone' ];then
         mkdir $url/enum/aquatone
 fi
 
echo "[+] Harvesting subdomains with Sublist3r..."
sublist3r -d $url -v -o $url/enum/sublist3r/subdomains.txt
sort -u $url/enum/sublist3r/subdomains.txt >> $url/enum/final.txt

echo "[+] Harvesting subdomains with Amass..."
amass enum -d $url >> $url/enum/amass/amass.txt
sort -u $url/enum/amass/amass.txt >> $url/enum/final.txt

echo "[+] Probing for alive domains with httprobe..."
cat $url/enum/final.txt | sort -u | httprobe -s -p https:443 | sed 's/https\?:\/\///' | tr -d ':443' >> $url/enum/httprobe/alive.txt

echo "[+] Running Aquatone against all compiled domains..."
cat $url/enum/httprobe/alive.txt | /home/kali/tools/aquatone -out $url/enum/aquatone

echo "[+] Nmap scanning for open ports..."
nmap -iL $url/enum/httprobe/alive.txt -T4 -oA $url/enum/nmap/nmap.txt

echo "[+] Grepping IPs from Nmap to Masscan..."
cat $url/enum/nmap/nmap.txt.gnmap | grep -i "Up" | awk '/Up/{print $2}' >> $url/enum/masscan/grepped_ips.txt
echo "[+] Grepping IPs to Masscan Complete..."

echo "[+] Masscan scanning for open ports..."
masscan -p1-65535 -iL $url/enum/masscan/grepped_ips.txt --rate 10000 -oG $url/enum/masscan/masscan_results.txt
