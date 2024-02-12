#!/bin/bash
set -e
#shopt -q
#
#******************************************************
#
# Per il check su nuove distribuzioni (p.e. Mint) agguingere il nome dell'array di comptenza senza spazi
# Script creato da Luigi Cassolini
# Si consiglia di posizionare lo script in /opt/cdpgk/
#
#*******************************************************
#
# Codice creato da Luigi Cassolini e distribuito con GPL V3.0
#
declare -a REDHAT_LIKE=( "RockyLinux" "Centos" "Rocky" )
declare -a DEBIAN_LIKE=( "Debian" "Ubuntu" )

DOWNLOAD="Download packages on"
OS=$(cat /etc/*release | grep ^NAME)
OS=$(echo $OS | tr -d ' ')
LINE="==============================================="
update_date=$(date +%d-%m-%Y)
update_time=$(date +%H:%M)
LOGpath="/opt/cdpkg/"
file="cron_download_update.log"
LOGfile="$LOGpath$file"
YUM=/usr/bin/yum
APT=/usr/bin/apt
PGEXC="--disablerepo=pgdg14 --disablerepo=zabbix --disablerepo=zabbix-agent2-plugins --disablerepo=pgdg-common"



#UPDATE per Piattaforme Red Hat Like
for i in "${REDHAT_LIKE[@]}"
do
        if  echo "$OS" | grep -q $i; then
                echo $LINE>$LOGfile
                echo "Execution date time: $update_date at $update_time">>$LOGfile
                echo $LINE>>$LOGfile
                $YUM check-update $PGEXC>>$LOGfile&&echo $LINE>>$LOGfile
                $YUM update --downloadonly $PGEXC -y>>$LOGfile&&echo $LINE>>$LOGfile
        fi
done


#UPDATE per Piattaforme Debian Like
for i in "${DEBIAN_LIKE[@]}"
do
        if  echo "$OS" | grep -q $i; then
                echo "Start at $update_date $update_time"
                echo $LINE>$LOGfile
                echo "Execution date time: $update_date at $update_time">>$LOGfile
                echo $LINE>>$LOGfile
                $APT update && echo $LINE>>$LOGfile
                $APT list --upgradable>>$LOGfile && $APT -y -d upgrade>>$LOGfile

        fi
done
echo $LINE>>$LOGfile
echo "End at $update_date $update_time">>$LOGfile
echo $LINE>>$LOGfile

exit 0
