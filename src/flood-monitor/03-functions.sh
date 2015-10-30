csf() { /usr/sbin/csf "$@"; }

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
    COMMENT=${2-"flooder"};
    csf -td $1 $DENY_TTL "$COMMENT" | tr "\n" ";";
    echo "";
}

floodDeny() {
    csf -d $1 $DENY_TTL flooder;
}

floodList() {
    compileIgnoreList;
    tail -n $((SAMPLE_SIZE * 200)) /var/log/httpd/access_log \
    | grep -v -f /tmp/kakashi-flood-ignore | tail -n $((SAMPLE_SIZE * 100)) | cut -d' ' -f 1,12-14 \
    | tr ' "' "\t" | tr "(" " " | sort | uniq -c | sort -gr| head -n $SAMPLE_SIZE > /tmp/kakashi-flood-result;
}

choiceActionForIp() {
    IP=$1;
    echo "Temporary Deny = t | Deny = d | More Info = i | Add to flood whitelist = a | ENTER for do nothing"
    read -p "Action for $IP? (t/d/i/a): " choice
    actionForIp $IP $choice
}

actionForIp() {
    IP=$1;
    ACTION=${2:-};
    COMMENT=${3:-};
    case "$ACTION" in
      t ) floodDenyTemp $IP "$COMMENT";;
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
               choiceActionForIp $IP;
           else
               echo -n "$executionId Default action for [$IP]: $DEFAULT_ACTION,";
               actionForIp $IP $DEFAULT_ACTION "Flood ($COUNT hits)"
           fi
       fi
    done
}
