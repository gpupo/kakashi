#!/bin/bash
#
#
testCase() { ./test.sh $1 $2 | grep -v "$3" | grep -e '^$' -v; }

for i in host-is-ratelimited host-lookup-did-not-complete could-not-complete-sender-verify \
courier_login-authenticator-failed 
do
    printf "\nMust MATCH on $i :\n";
    testCase "./regex/${i}.pl" "./dataprovider/${i}.txt" "Match";
    printf "\nMust NOT match on $i :\n";
    testCase "./regex/${i}.pl" "./dataprovider/notMatch.txt" "Fail";
done
