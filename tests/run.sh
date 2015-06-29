#!/bin/bash
#
# This file is part of gpupo/kakashi
# https://github.com/gpupo/kakashi
#
# (c) Gilmar Pupo <g@g1mr.com>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.

testCase() { ./test.sh $1 $2 | grep -v "$3" | grep -e '^$' -v; }

for i in host-is-ratelimited host-lookup-did-not-complete could-not-complete-sender-verify \
courier_login-authenticator-failed absurd-spamscore
do
    printf "\nMust MATCH on $i :\n";
    testCase "./regex/${i}.pl" "./dataprovider/${i}.txt" "Match";
    printf "\nMust NOT match on $i :\n";
    testCase "./regex/${i}.pl" "./dataprovider/notMatch.txt" "Fail";
done
