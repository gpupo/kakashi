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
# Monitor and Blocking for 6 hours IPs with more than 350 connections
# or reverse ip is in ~/.kakashi/reverse.deny list
#
# Crontab line:
# */2 * * * * ~/kakashi/bin/crontab-script-default.sh >> /var/log/kakashi-flood-monitor.log 2>&1

DEFAULT_ACTION=t;
MEDIAN=350;
DENY_TTL=6h;
REVERSE_CHECK=true;

lockfile -r 0 /tmp/kakashi-cron-script.lock || exit 1

alias csf="/usr/sbin/csf";
source ~/kakashi/bin/flood-monitor.sh

rm -f /tmp/kakashi-cron-script.lock;
