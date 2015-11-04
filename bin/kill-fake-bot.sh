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
       printf '\n\n====FAKE DETECTED ==== ';
       grep -m 1 $IP /var/log/httpd/access_log;
       echo -n "$executionId Fake bot [$IP=>$h] Action: $DEFAULT_ACTION,";
       actionForIp $IP $DEFAULT_ACTION "$h FAKE BOT"
   fi
done

printf '\n\n====SUMMARY ====';

list=(TweetmemeBot trendictionbot adsbot msnbot YandexImageResizer SurdotlyBot \
MJ12bot Googlebot DotBot bingbot archive.org_bot facebookexternalhit brandwatch \
Mediapartners-Google python-requests okhttp MiniRedir uhChat facebookplatform);

for item in "${list[@]}"
do
    echo -n "${item}:";
    grep -c "${item}" /var/log/httpd/access_log
done

grep  cron /var/log/httpd/access_log | cut -d " " -f1 | sort -u

tail -f /var/log/httpd/access_log | grep -v "Mozilla/5.0\|Pingdom\|IPN\|TweetmemeBot\|trendictionbot\|adsbot\|msnbot\|YandexImageResizer\|SurdotlyBot\|MJ12bot\|Googlebot\|DotBot\|bingbot\|archive.org_bot\|facebookexternalhit"
