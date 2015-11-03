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

#deny
csf -t | grep "opera\|in-addr" | cut -d " " -f3 | cut -d "." -f 1-3 | sort -u | awk '{print "csf -d "$1".0/16 \"KAKASHI CIDR BLACKLISTED\";"}' > /tmp/kakash-cdir-deny-tmp-rbl
wget --quiet -O- https://ip-ranges.amazonaws.com/ip-ranges.json | grep ip | cut -d "\"" -f4| grep "\/" | awk '{print "csf -d "$1" \"KAKASHI CIDR AWS\";"}' >  /tmp/kakash-cdir-deny-amazon

#allow
whois -h whois.radb.net -- '-i origin AS32934' | grep ^route: | cut -d " " -f7 | grep "\/" | awk '{print "csf -a "$1" \"KAKASHI CIDR FACEBOOK\";"}' > /tmp/kakash-cdir-allow-facebook
wget --quiet -O- https://www.pingdom.com/rss/probe_servers.xml | perl -nle 'print $1 if /IP: (([01]?\d\d?|2[0-4]\d|25[0-5])\.([01]?\d\d?|2[0-4]\d|25[0-5])\.([01]?\d\d?|2[0-4]\d|25[0-5])\.([01]?\d\d?|2[0-4]\d|25[0-5]));/' \
| awk '{print "csf -a "$1" \"KAKASHI CIDR PINGDOM\";"}' | tee  /tmp/kakash-cdir-allow-pingdom

cat /tmp/kakash-cdir-allow-* | sort -u > ~/.kakashi/allow.sh
cat /tmp/kakash-cdir-deny-* | sort -u > ~/.kakashi/deny.sh
