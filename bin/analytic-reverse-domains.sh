cat /var/log/kakashi-flood-reverse-monitor.log | grep "reverse" |\
grep -v -f ~/.kakashi/reverse.allow | grep -v -f ~/.kakashi/reverse.deny | \
cut -d "," -f 2 | sort -u  > ~/.kakashi/reverse.domains.txt
