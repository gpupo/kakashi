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
# build-2015-11-06-09h06 | source: src/flood-monitor/
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
floodList() {
    compileIgnoreList;
    tail -n 20000 $HTTPD_LOG_PATH \
    | grep -v -f /tmp/kakashi-flood-ignore | tail -n 10000 | cut -d' ' -f 1,12-14 \
    | tr ' "' "\t" | tr "(" " " | sort | uniq -c | sort -gr| head -n $SAMPLE_SIZE > /tmp/kakashi-flood-result;
}

compileIgnoreList() {
    csf -t | cut -d " " -f 3 | grep -v ^$ > /tmp/kakashi-flood-ignore;
    grep -v "^$\|^#" /etc/csf/csf.allow | cut -d '.' -f1,2,3 | uniq >> /tmp/kakashi-flood-ignore;
    grep -v ^$ ~/.kakashi/allow >> /tmp/kakashi-flood-ignore;
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
