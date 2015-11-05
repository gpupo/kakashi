#!/bin/bash
#
#  This file is part of gpupo/kakashi
# http://www.g1mr.com/kakashi
#
# (c) Gilmar Pupo <g@g1mr.com>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.

APP_PATH="$(dirname $0)";
source $APP_PATH/common.sh;

floodDailyList() {
    cut -d " " -f1 /var/log/httpd/access_log | grep -v -f /tmp/kakashi-flood-ignore | sort | uniq -c | sort -gr| head -n 50 > /tmp/kakashi-daily-result;
}

for L in `cat /tmp/kakashi-daily-result| tr -s " "| tr "\t" ";" | tr " " ";"`;do
    IP=$(echo $L | cut -d ";" -f 3)
    COUNT=$(echo $L | cut -d ";" -f 2)
    if [ "$COUNT" -gt 900 ]; then
        if csf -g $IP | grep -q "csf.deny\|csf.allow\|Temporary Blocks"; then
            printf "\n * Bypass $IP\n";
        else
            info=$(csf -i $IP | cut -d "(" -f2 | cut -d ")" -f1);
            country=$(echo $info | cut -d "/" -f1);
            if [ "$country" ==  "BR" ]; then
                printf "\nBR,$IP,$info,$count\n";
            else
                actionForIp $IP $DEFAULT_ACTION "KAKASHI Daily limit reached from  ($COUNT)";
            fi
        fi
    fi

done
