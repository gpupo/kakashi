#!/bin/bash
#
#  This file is part of gpupo/kakashi
# https://opensource.gpupo.com/kakashi
#
# (c) Gilmar Pupo <contact@gpupo.com>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.

APP_PATH="$(dirname $0)";
source $APP_PATH/common.sh;

CUSTOM_LOG_PATH=${1:-$HTTPD_LOG_PATH};

cut -d " " -f1 $CUSTOM_LOG_PATH | grep -v -f /tmp/kakashi-flood-ignore | sort | uniq -c | sort -gr| head -n 50 > /tmp/kakashi-daily-result;

printf "\n";

for L in `cat /tmp/kakashi-daily-result| tr -s " "| tr "\t" ";" | tr " " ";"`;do
    IP=$(echo $L | cut -d ";" -f 3)
    COUNT=$(echo $L | cut -d ";" -f 2)
    if [ "$COUNT" -gt 700 ]; then
        if csf -g $IP | grep -q "csf.deny\|csf.allow\|Temporary Blocks"; then
            printf " * Bypass $IP\n";
        else
            info=$(csf -i $IP | cut -d "(" -f2 | cut -d ")" -f1);
            country=$(echo $info | cut -d "/" -f1);
            if [ "$country" ==  "BR" ]; then
                printf "$IP,$info,$COUNT\n";
            else
                printf "Temporary Block $IP,$info,$COUNT\n";
                actionForIp $IP $DEFAULT_ACTION "KAKASHI Daily limit reached from $info ($COUNT)";
                printf "\n";
            fi
        fi
    fi

done

printf "\n Done! \n";
