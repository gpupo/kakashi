floodGrep() {
    echo "";
    grep $1 /var/log/httpd/access_log | tail -n 30 | cut -c1-120 | uniq;
    echo "";
    choiceActionForIp $1;
}

compileIgnoreList() {
    csf -t | cut -d " " -f 3 | grep -v ^$ > /tmp/kakashi-flood-ignore;
    grep -v "^$\|^#" /etc/csf/csf.allow | cut -d '.' -f1,2,3 | uniq >> /tmp/kakashi-flood-ignore;
    grep -v ^$ ~/.kakashi/allow >> /tmp/kakashi-flood-ignore;
}

floodAllow() {
    echo $1 >> ~/.kakashi/allow;
}

floodDenyTemp() {
    csf -td $1 $DENY_TTL flooder;
}

floodDeny() {
    csf -d $1 $DENY_TTL flooder;
}

floodList() {
    compileIgnoreList;
    tail -n 20000 /var/log/httpd/access_log \
    | grep -v -f /tmp/kakashi-flood-ignore | tail -n 10000 | cut -d' ' -f 1,12-14 \
    | tr ' "' "\t" | tr "(" " " | sort | uniq -c | sort -gr| head -n 20 \
    | tee /tmp/kakashi-flood-result;
}

choiceActionForIp() {
    IP=$1;
    echo "Temporary Deny = t | Deny = d | More Info = i | Add to flood whitelist = a | ENTER for do nothing"
    read -p "Action for $IP? (d/i/a): " choice
    actionForIp $IP $choice
}

actionForIp() {
    IP=$1;
    ACTION=${2:-};
    case "$ACTION" in
      t ) floodDenyTemp $IP;;
      d ) floodDeny $IP;;
      i ) floodGrep $IP;;
      a ) floodAllow $IP;;
      * ) echo "none";;
    esac
}

floodMonitor() {
    for L in `cat /tmp/kakashi-flood-result| tr -s " "| tr "\t" ";" | tr " " ";"`;do
       COUNT=$(echo $L | cut -d ";" -f 2)
       IP=$(echo $L | cut -d ";" -f 3)

       if [ "$COUNT" -gt "$MEDIAN" ]; then
           if [ "$DEFAULT_ACTION" == "" ];then
               echo "Default action: $DEFAULT_ACTION";
               actionForIp $IP $DEFAULT_ACTION
           else
               choiceActionForIp $IP;
           fi
       fi
    done
}
