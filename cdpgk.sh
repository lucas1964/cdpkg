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

#UPDATE per Piattaforme Red Hat Like
for i in "${REDHAT_LIKE[@]}"
do
        if  echo "$OS" | grep -q $i; then
                echo $LINE>cron_download_update.log
                echo "Execution date time: $update_date at $update_time">>cron_download_update.log
                echo $LINE>>cron_download_update.log
                yum check-update>>cron_download_update.log
                yum update --downloadonly -y
                echo $LINE>>cron_download_update.log
        fi
done

#UPDATE per Piattaforme Debian Like
for i in "${DEBIAN_LIKE[@]}"
do
        if  echo "$OS" | grep -q $i; then
                echo "Start at $update_date $update_time"
                echo $LINE>cron_download_update.log
                echo "Execution date time: $update_date at $update_time">>cron_download_update.log
                echo $LINE>>cron_download_update.log
                /usr/bin/apt update &> /dev/null
                /usr/bin/apt list --upgradable>>cron_download_update.log 2> /dev/null
                /usr/bin/apt -y -d upgrade &> /dev/null

        fi
done
echo $LINE>>cron_download_update.log
echo "End at   $update_date $update_time">>cron_download_update.log
echo $LINE>>cron_download_update.log
exit 0
