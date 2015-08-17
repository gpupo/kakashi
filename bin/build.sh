#!/bin/bash
RELEASE_ID=$(date +build-%Y-%m-%d-%Hh%M);

cat src/00-header.pl > regex.custom.pm;
echo "# $RELEASE_ID" >> regex.custom.pm;
cat src/00-init.pl src/mta/* src/http/* src/99-footer.pl >> regex.custom.pm;
