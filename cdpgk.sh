#!/bin/bash
set -e
shopt -q
#
#******************************************************
#
# Per il check su nuove distribuzioni (p.e. Mint) agguingere il nome dell'array di comptenza
# Script creato da Luigi Cassolini
# Si consiglia di posizionare lo script in /opt/cdpgk/
#
#*******************************************************
#
# Codice creato da Luigi Cassolini e distribuito con GPL V3.0
#
declare -a REDHAT_LIKE=( "Rocky" "Centos" )
declare -a DEBIAN_LIKE=( "Debian" "Ubuntu" )

DOWNLOAD="Download packages on"
OS=$(cat /etc/*release | grep ^NAME)
LINE="==============================================="
update_date=$(date +%d-%m-%Y)
update_time=$(date +%H:%M)
LOGpath="/opt/cdpkg/"
file="cron_download_update.log"
LOGfile="$LOGpath$file"

#UPDATE per Piattaforme Red Hat Like
for i in "${REDHAT_LIKE[@]}"
do
        if  echo "$OS" | grep -q $i; then
                echo $LINE>cron_download_update.log
                echo "Execution date time: $update_date at $update_time">>$LOGfile
                echo $LINE>>$LOGfile
                yum check-update>>$LOGfile
                yum update --downloadonly -y
                echo $LINE>>$LOGfile
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
                /usr/bin/apt update &> /dev/null
                /usr/bin/apt list --upgradable>>$LOGfile 2> /dev/null
                /usr/bin/apt -y -d upgrade &> /dev/null

        fi
done
echo $LINE>>$LOGfile
echo "End at   $update_date $update_time">>$LOGfile
echo $LINE>>$LOGfile
echo "End at $update_date $update_time"
exit 0
