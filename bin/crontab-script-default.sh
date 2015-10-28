#!/bin/bash
# Monitor and Blocking for 6 hours IPs with more than 350 connections
# or reverse ip is in ~/.kakashi/reverse.deny list
#
# Crontab line:
# */2 * * * * ~/kakashi/bin/crontab-script-default.sh >> /var/log/kakashi-flood-monitor.log 2>&1

DEFAULT_ACTION=t;
MEDIAN=350;
DENY_TTL=1h;
REVERSE_CHECK=true;
alias csf="/usr/sbin/csf";
printf "\n\n--$(date)---\n\n";
source ~/kakashi/bin/flood-monitor.sh
