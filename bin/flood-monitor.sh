#!/bin/bash
#
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
#
# build-2015-10-29-14h06 | source: src/flood-monitor/
#
##

# Tool for checking high hits on httpd server
#
# Actions:
# - t) Temporary Deny
# - d) Deny
# - i) Info
# - a) Add to flood whitelist
#
# Usage
#
# - Interactive mode:
# ~/kakashi/bin/flood-monitor.sh
#
# - Non interactive With parameters:
# export DEFAULT_ACTION=t; export MEDIAN=300; export DENY_TTL=6h; ~/kakashi/bin/flood-monitor.sh
#
MEDIAN=${MEDIAN:-300};
DENY_TTL=${DENY_TTL:-2h};
DEFAULT_ACTION=${DEFAULT_ACTION:-};
REVERSE_CHECK=${REVERSE_CHECK:-false};

touch ~/.kakashi/allow ~/.kakashi/reverse.deny ~/.kakashi/reverse.allow
executionId=$(date +%Y-%m-%d-%H:%M);
csf() { /usr/sbin/csf "$@" | tr "\n" ";"; }

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

floodDenyTemp() {
    COMMENT=${2-"flooder"};
    csf -td $1 $DENY_TTL "$COMMENT";
    echo "";
}

floodDeny() {
    csf -d $1 $DENY_TTL flooder;
}

floodList() {
    compileIgnoreList;
    tail -n 20000 /var/log/httpd/access_log \
    | grep -v -f /tmp/kakashi-flood-ignore | tail -n 10000 | cut -d' ' -f 1,12-14 \
    | tr ' "' "\t" | tr "(" " " | sort | uniq -c | sort -gr| head -n 100 > /tmp/kakashi-flood-result;
}

choiceActionForIp() {
    IP=$1;
    echo "Temporary Deny = t | Deny = d | More Info = i | Add to flood whitelist = a | ENTER for do nothing"
    read -p "Action for $IP? (t/d/i/a): " choice
    actionForIp $IP $choice
}

actionForIp() {
    IP=$1;
    ACTION=${2:-};
    COMMENT=${3:-};
    case "$ACTION" in
      t ) floodDenyTemp $IP "$COMMENT";;
      d ) floodDeny $IP;;
      i ) floodGrep $IP;;
      a ) floodAllow $IP;;
      * ) echo "none";;
    esac
}

floodMonitor() {
    for L in `cat /tmp/kakashi-flood-result| tr -s " "| tr "\t" ";" | tr " " ";"`;do
       COUNT=$(echo $L | cut -d ";" -f 2)
       IP=$(echo $L | cut -d ";" -f 3)

       if [ "$COUNT" -gt "$MEDIAN" ]; then
           if [ "$DEFAULT_ACTION" == "" ];then
               choiceActionForIp $IP;
           else
               echo "Default action: $DEFAULT_ACTION";
               actionForIp $IP $DEFAULT_ACTION
           fi
       fi
    done
}

reverseDNSLookupDomain() {
    host $1 | rev | cut -d "." -f2-3 | rev | sed 's/arpa domain name pointer //g';
};

reverseMonitor() {
    for L in `cat /tmp/kakashi-flood-result| tr -s " "| tr "\t" ";" | tr " " ";"`;do
       IP=$(echo $L | cut -d ";" -f 3)
       COUNT=$(echo $L | cut -d ";" -f 2)
       reverseDomain=$(reverseDNSLookupDomain $IP);
       listed=0;
       if grep -q "$reverseDomain" ~/.kakashi/reverse.deny; then
           listed=1;
           if [ "$DEFAULT_ACTION" == "" ];then
               choiceActionForIp $IP;
           else
               echo -n "$executionId) Default action for [$reverseDomain]: $DEFAULT_ACTION,";
               actionForIp $IP $DEFAULT_ACTION "$reverseDomain REVERSE BLACKLISTED"
           fi
       fi

       echo "reverse,$reverseDomain,$IP,$listed,$COUNT" >> /var/log/kakashi-flood-reverse-monitor.log ;
    done
}
floodList;
floodMonitor;

if [ "$REVERSE_CHECK" == true ]; then
    reverseMonitor;
fi
