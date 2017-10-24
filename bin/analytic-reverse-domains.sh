#!/bin/bash
#
#  This file is part of gpupo/kakashi
# https://opensource.gpupo.com/kakashi
#
# (c) Gilmar Pupo <contact@gpupo.com>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
#
##

kakashi-reverse-reorder-list() {
    cat ~/.kakashi/reverse.$1 | sort -u > /tmp/kakashi-reverse.$1;
    cat /tmp/kakashi-reverse.$1  > ~/.kakashi/reverse.$1;
    echo "Ordered $1 List";
}

kakashi-reverse-add-to-list() {
    echo "* Add $1 to [$2] list";
    echo "$1" >> ~/.kakashi/reverse.$2;
}

kakashi-reverse-deny() {
    kakashi-reverse-add-to-list $1 "deny";
}

kakashi-reverse-allow() {
    kakashi-reverse-add-to-list $1 "allow";
}

kakashi-reverse-suspect() {
    kakashi-reverse-add-to-list $1 "suspect";
}

domain-whois-info() {
    echo "=====$L=====";
    whois "$1" | grep Registr;
}

actionForDomain() {
    DOMAIN=$1;
    ACTION=${2:-};
    case "$ACTION" in
      d ) kakashi-reverse-deny $DOMAIN;;
      a ) kakashi-reverse-allow $DOMAIN;;
      s ) kakashi-reverse-suspect $DOMAIN;;
      * ) echo "none";;
    esac
}


cat /var/log/kakashi-flood-reverse-monitor.log | grep "reverse" |\
grep -v -f ~/.kakashi/reverse.allow | grep -v -f ~/.kakashi/reverse.deny | grep -v -f ~/.kakashi/reverse.suspect | \
cut -d "," -f 2 | sort -u  | tee ~/.kakashi/reverse.domains.txt

for L in `cat ~/.kakashi/reverse.domains.txt`;do
   domain-whois-info $L;
   echo "Deny = d | Add to flood whitelist = a | Suspect = s | ENTER for do nothing"
   read -p "Action for $L? (d/a/s): " choice
   actionForDomain $L $choice
   printf "\n\n";
done


kakashi-reverse-reorder-list deny
kakashi-reverse-reorder-list allow
kakashi-reverse-reorder-list suspect
