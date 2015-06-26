#!/usr/bin/perl

$line = $ARGV[0];

if ($line =~ /^[a-zA-Z0-9:=().-\s]{2,}\[(\S+)\]:[a-zA-Z0-9=<\-@.>\s]{2,}:\s+Could not complete sender verify/) {
    printf "Match!";
} else {
    printf "\nFail:${line}\n";
}
