#!/usr/bin/perl

$line = $ARGV[0];

if ($line =~ /^[a-zA-Z0-9:=().-\s]{2,}courier_login authenticator failed for\s+[\S\s]{2,}\[(\S+)\]:\d+:\s+\d+\sIncorrect authentication data\s+\S+/)  {
    printf "[$1] Match!\n";
} else {
    print "\nFail:${line}\n";
}
