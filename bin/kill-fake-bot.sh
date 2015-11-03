#!/bin/bash
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
