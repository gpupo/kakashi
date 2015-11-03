#!/bin/bash
APP_PATH="$(dirname $0)";
source $APP_PATH/common.sh;

for IP in `grep "Googlebot\|bingbot\|msnbot\|adsbot" /var/log/httpd/access_log | cut -d " " -f1 | sort -u`;do
   h=$(host "$IP" | tr "\n" " " | rev | cut -d "." -f2-3 | rev)
   if grep -q "$h" ~/kakashi/data/bots; then
       echo "$executionId Ok bot [$h]";
   else
       echo "$executionId Fake bot [$IP=>$h]";
       grep -m 200 $IP /var/log/httpd/access_log;
   fi
done
