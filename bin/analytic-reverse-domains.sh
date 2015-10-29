cat /var/log/kakashi-flood-reverse-monitor.log | grep "reverse" |\
grep -v -f ~/.kakashi/reverse.allow | grep -v -f ~/.kakashi/reverse.deny | \
cut -d "," -f 2 | sort -u  | tee ~/.kakashi/reverse.domains.txt

#Reorder Deny List
kakashi-reverse-reorder-list() {
    cat ~/.kakashi/reverse.deny | sort -u > /tmp/kakashi-reverse-deny; cat /tmp/kakashi-reverse-deny  > ~/.kakashi/reverse.deny;
}

kakashi-reverse-deny() { echo "$1" >> ~/.kakashi/reverse.deny; }
