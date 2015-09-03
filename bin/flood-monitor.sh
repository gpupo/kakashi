#!/bin/bash
# This file is part of gpupo/kakashi
# http://www.g1mr.com/kakashi
#
# (c) Gilmar Pupo <g@g1mr.com>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
#
# Warning: This file is generated automatically.
# To improve it, see bin/build.sh and edit the corresponding source code
# build-2015-09-03-09h41
# Tool for checking high hits on httpd server
MEDIAN=300;
DENY_TTL="2h";
floodGrep() {
    echo "";
    grep $1 /var/log/httpd/access_log | tail -n 30 | cut -c1-120 | uniq;
    echo "";
    choiceActionForIp $1;
}

compileIgnoreList() {
    csf -t | cut -d " " -f 3 | grep -v ^$ > /tmp/kakashi-flood-ignore;
    grep -v "^$\|^#" /etc/csf/csf.allow | cut -d '.' -f1,2,3 | uniq >> /tmp/kakashi-flood-ignore;
    grep -v ^$ ~/.kakashi/allow >> /tmp/kakashi-flood-ignore;
}

floodAllow() {
    echo $1 >> ~/.kakashi/allow;
}

floodDeny() {
    csf -td $1 $DENY_TTL flooder;
}

floodList() {
    compileIgnoreList;
    tail -n 20000 /var/log/httpd/access_log \
    | grep -v -f /tmp/kakashi-flood-ignore | tail -n 10000 | cut -d' ' -f 1,12-14 \
    | tr ' "' "\t" | tr "(" " " | sort | uniq -c | sort -gr| head -n 20 \
    | tee /tmp/kakashi-flood-result;
}

choiceActionForIp() {
    IP=$1;
    echo "Deny = d | More Info = i | Add to flood whitelist = a | ENTER for do nothing"
    read -p "Action for $IP? (d/i/a): " choice
    case "$choice" in
      dD ) floodDeny $IP;;
      iI ) floodGrep $IP;;
      aA ) floodAllow $IP;;
      * ) echo "none";;
    esac
}

floodMonitor() {
    for L in `cat /tmp/kakashi-flood-result| tr -s " "| tr "\t" ";" | tr " " ";"`;do
       COUNT=$(echo $L | cut -d ";" -f 2)
       IP=$(echo $L | cut -d ";" -f 3)

       if [ "$COUNT" -gt "$MEDIAN" ]; then
           choiceActionForIp $IP;
       fi
    done
}
floodList;
floodMonitor
