#!/bin/bash
RELEASE_ID=$(date +build-%Y-%m-%d-%Hh%M);

# Custom
echo '#!/usr/bin/perl' > regex.custom.pm;
cat src/00-header.pl >> regex.custom.pm;
echo "# $RELEASE_ID" >> regex.custom.pm;
cat src/00-init.pl src/mta/* src/http/* >> regex.custom.pm;


#Sharingan
cat regex.custom.pm > regex.sharingan.pm;
cat src/sharingan/* >> regex.sharingan.pm;

cat src/99-footer.pl  >> regex.custom.pm;
cat src/99-footer.pl  >> regex.sharingan.pm;



whitelist_command() {
    while read -r line
    do
        echo "csf -a $line \"Kakashi $1 whitelist database\";";
    done <  data/ip/whitelist/$1.txt;
}

#bin
echo '#!/bin/bash' > bin/csf-add-whitelist.sh;
cat src/00-header.pl >> bin/csf-add-whitelist.sh;
cat data/ip/whitelist/00-README.md >> bin/csf-add-whitelist.sh;
echo "# $RELEASE_ID" >> bin/csf-add-whitelist.sh;
whitelist_command gmail >> bin/csf-add-whitelist.sh;
whitelist_command outlook >> bin/csf-add-whitelist.sh;
chmod +x bin/csf-add-whitelist.sh;
