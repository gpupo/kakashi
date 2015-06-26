#!/bin/bash
#
testCase() { ./test.sh  ./regex/${1}.pl ./dataprovider/${1}.txt; }

for i in host-is-ratelimited host-lookup-did-not-complete temporarily-rejected-RCPT
do
    printf "$i :\n";
    testCase $i;
done
