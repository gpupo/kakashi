
reverseDNSLookupDomain() {
    host $1 | rev | cut -d "." -f2-3 | rev | sed 's/arpa domain name pointer //g';
};

reverseMonitor() {
    for L in `cat /tmp/kakashi-flood-result| tr -s " "| tr "\t" ";" | tr " " ";"`;do
       IP=$(echo $L | cut -d ";" -f 3)
       COUNT=$(echo $L | cut -d ";" -f 2)
       reverseDomain=$(reverseDNSLookupDomain $IP);
       listed=0;
       if grep -q "$reverseDomain" ~/.kakashi/reverse.deny; then
           listed=1;
           if [ "$DEFAULT_ACTION" == "" ];then
               choiceActionForIp $IP;
           else
               echo -n "Default action for [$reverseDomain]: $DEFAULT_ACTION,";
               actionForIp $IP $DEFAULT_ACTION "$reverseDomain REVERSE BLACKLISTED"
           fi
       fi

       echo "reverse,$reverseDomain,$IP,$listed,$COUNT" >> /var/log/kakashi-flood-reverse-monitor.log ;
    done
}
