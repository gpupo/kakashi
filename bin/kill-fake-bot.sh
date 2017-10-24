#!/bin/bash
#
#  This file is part of gpupo/kakashi
# https://opensource.gpupo.com/kakashi
#
# (c) Gilmar Pupo <contact@gpupo.com>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.

APP_PATH="$(dirname $0)";
source $APP_PATH/common.sh;

for IP in `grep "Googlebot\|bingbot\|msnbot\|adsbot\|paraisobot\|python-requests\|Slurp" $HTTPD_LOG_PATH \
| grep -v "\"$" \
| grep -v -f /tmp/kakashi-flood-ignore | cut -d " " -f1 | sort -u`;do
    h=$(host "$IP" | tr "\n" " " | rev | cut -d "." -f2-3 | rev);
    if grep -q "$h" ~/kakashi/data/bots; then
        continue;
    else
        printf '\n\n====FAKE DETECTED ==== ';
        grep -m 10 $IP $HTTPD_LOG_PATH;
        echo -n "$executionId Fake bot [$IP=>$h] Action: $DEFAULT_ACTION,";
        actionForIp $IP $DEFAULT_ACTION "$h FAKE BOT";
    fi
done

printf '\n\n====SUMMARY ====\n\n';

list=(TweetmemeBot trendictionbot adsbot msnbot YandexImageResizer SurdotlyBot \
MJ12bot Googlebot DotBot bingbot archive.org_bot facebookexternalhit brandwatch \
Mediapartners-Google python-requests okhttp MiniRedir uhChat facebookplatform \
Genieo Feedly HttpClient Slurp Riddler Links paraisobot);

for item in "${list[@]}"
do
    echo -n "${item}:";
    grep -c "${item}" $HTTPD_LOG_PATH
done

printf '\n\n====Type 2 ====\n\n';

grep  "cron\|license" $HTTPD_LOG_PATH | cut -d " " -f1 | sort -u
