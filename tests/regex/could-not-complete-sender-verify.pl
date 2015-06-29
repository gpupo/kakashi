#!/usr/bin/perl

$line = $ARGV[0];

if ($line =~ /^[a-zA-Z0-9:=().-\s]{2,}\[(\S+)\]:[a-zA-Z0-9=<\-@.>\s]{2,}:\s+Could not complete sender verify/) {
    printf "[$1] Match!\n";
} else {
    printf "\nFail:${line}\n";
}
