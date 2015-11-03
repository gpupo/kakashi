#!/bin/bash
#
#  This file is part of gpupo/kakashi
# http://www.g1mr.com/kakashi
#
# (c) Gilmar Pupo <g@g1mr.com>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
#

SAMPLE_SIZE=${SAMPLE_SIZE:-100};
MEDIAN=${MEDIAN:-300};
DENY_TTL=${DENY_TTL:-2h};
DEFAULT_ACTION=${DEFAULT_ACTION:-};
REVERSE_CHECK=${REVERSE_CHECK:-false};
touch ~/.kakashi/allow ~/.kakashi/reverse.deny ~/.kakashi/reverse.allow ~/.kakashi/reverse.suspect ~/.kakashi/config

#Custom config file for overwrite default values
source ~/.kakashi/config
executionId=$(date +%Y-%m-%d-%H:%M);


csf() { /usr/sbin/csf "$@"; }

floodGrep() {
    echo "";
    grep $1 /var/log/httpd/access_log | tail -n 30 | cut -c1-120 | uniq;
    echo "";
    choiceActionForIp $1;
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

choiceActionForIp() {
    IP=$1;
    echo "Temporary Deny = t | Deny = d | More Info = i | Add to flood whitelist = a | ENTER for do nothing"
    read -p "Action for $IP? (t/d/i/a): " choice
    actionForIp $IP $choice
}
