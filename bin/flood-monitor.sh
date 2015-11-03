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
# build-2015-11-03-10h46 | source: src/flood-monitor/
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

APP_PATH="$(dirname $0)";
source $APP_PATH/common.sh;
csf() { /usr/sbin/csf "$@"; }

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
    csf -td $1 $DENY_TTL "$COMMENT" | tr "\n" ";";
    echo "";
}

floodDeny() {
    csf -d $1 $DENY_TTL flooder;
}

floodList() {
    compileIgnoreList;
    tail -n 20000 /var/log/httpd/access_log \
    | grep -v -f /tmp/kakashi-flood-ignore | tail -n 10000 | cut -d' ' -f 1,12-14 \
    | tr ' "' "\t" | tr "(" " " | sort | uniq -c | sort -gr| head -n $SAMPLE_SIZE > /tmp/kakashi-flood-result;
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
               echo -n "$executionId Default action for [$IP]: $DEFAULT_ACTION,";
               actionForIp $IP $DEFAULT_ACTION "Flood ($COUNT hits)"
           fi
       fi
    done
}

reverseDNSLookupDomain() {
    host "$1" | tr "\n" " " | rev | cut -d "." -f2-3 | rev | sed 's/arpa domain name pointer //g';
}

reverseDNSLookup() {
    r=$(reverseDNSLookupDomain $1);
    if [ $r == 'in-addr.arpa' ]; then
        reverseDNSLookupDomain "$(echo $1|cut -d '.' -f1-2).1.1";
    else
         echo $r;
    fi;
}

reverseMonitor() {
    for L in `cat /tmp/kakashi-flood-result| tr -s " "| tr "\t" ";" | tr " " ";"`;do
       IP=$(echo $L | cut -d ";" -f 3)
       COUNT=$(echo $L | cut -d ";" -f 2)
       reverseDomain=$(reverseDNSLookup $IP);
       listed=0;
       if grep -q "$reverseDomain" ~/.kakashi/reverse.deny; then
           listed=1;
           if [ "$DEFAULT_ACTION" == "" ];then
               choiceActionForIp $IP;
           else
               echo -n "$executionId Default action for [$reverseDomain]: $DEFAULT_ACTION,";
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


echo "$executionId done";
