#!/bin/bash

reverseDNSLookupDomain() {
    host $1 | tr "\n" " " | rev | cut -d "." -f2-3 | rev;
}

for IP in `grep "Googlebot\|bingbot\|msnbot\|adsbot" /var/log/httpd/access_log | cut -d " " -f1 | sort -u`;do
   h=reverseDNSLookupDomain $IP
   echo $h
done
