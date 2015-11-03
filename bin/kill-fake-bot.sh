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

for IP in `grep "Googlebot\|bingbot\|msnbot\|adsbot" /var/log/httpd/access_log | cut -d " " -f1 | sort -u`;do
   h=$(host "$IP" | tr "\n" " " | rev | cut -d "." -f2-3 | rev)
   if grep -q "$h" ~/kakashi/data/bots; then
      continue;
   else
       grep -m 10 $IP /var/log/httpd/access_log;
       echo -n "$executionId Fake bot [$IP=>$h] Action: $DEFAULT_ACTION,";
       actionForIp $IP $DEFAULT_ACTION "$h FAKE BOT"
   fi
done
