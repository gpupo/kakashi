#!/usr/bin/perl

$line = $ARGV[0];

if ($line =~ /^[a-zA-Z0-9:=().-\s]{2,}\[(\S+)\]:[a-zA-Z0-9=<\-@.>\s]{2,}:\s+host lookup did not complete/) {
    printf "Match!";
} else {
    print "\nFail:${line}\n";
}
