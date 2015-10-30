#!/bin/bash
APP_PATH="$(dirname $0)";
source $APP_PATH/build-functions.sh;

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
