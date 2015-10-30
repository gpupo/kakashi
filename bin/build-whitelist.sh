#!/bin/bash
APP_PATH="$(dirname $0)";
source $APP_PATH/build-functions.sh;

whitelist_command() {
    while read -r line
    do
        echo "csf -a $line \"Kakashi $1 whitelist database\";";
    done <  data/ip/whitelist/$1.txt;
}

#bin
initFile bin/csf-add-whitelist.sh "src: data/ip/whitelist";
cat data/ip/whitelist/00-README.md >> bin/csf-add-whitelist.sh;
cat data/ip/whitelist/reverse.sh >> bin/csf-add-whitelist.sh;
echo '# CSF whitelist IP address ranges, contribution of Cleber Souza' >> bin/csf-add-whitelist.sh;
whitelist_command gmail >> bin/csf-add-whitelist.sh;
whitelist_command outlook >> bin/csf-add-whitelist.sh;
