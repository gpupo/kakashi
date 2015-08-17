#!/bin/bash
#
# This file is part of gpupo/kakashi
# http://www.g1mr.com/kakashi
#
# (c) Gilmar Pupo <g@g1mr.com>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.

APP_PATH="$(dirname $0)";

testCase() { ${APP_PATH}/test.sh $1 $2 | grep -v "$3" | grep -e '^$' -v; }

for i in host-is-ratelimited host-lookup-did-not-complete could-not-complete-sender-verify \
courier_login-authenticator-failed absurd-spamscore http-login-failed
do
    printf "\nMust MATCH on $i :\n";
    testCase "${APP_PATH}/regex/${i}.pl" "${APP_PATH}/dataprovider/${i}.txt" "Match";
    printf "\nMust NOT match on $i :\n";
    testCase "${APP_PATH}/regex/${i}.pl" "${APP_PATH}/dataprovider/notMatch.txt" "Fail";
done
